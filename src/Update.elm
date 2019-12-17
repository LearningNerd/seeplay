module Update exposing (update)


import Msg exposing (..)
import Dict exposing (Dict)
import Array exposing (..)
import Browser
import Random
import Tuple exposing (..)
import Task
import Time
import Json.Encode as E

import ConstantsHelpers as Const
import Physics
import Model exposing (Model(..), GameModel, Player, Vector, initialGameModel)
import Note exposing (Note)
import Level exposing (Level)
import Ports

import View.Player
import View.Target


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case model of

---------------------   LOADING SCREEN   --------------------
      LoadingScreen ->
        case msg of

            InitMIDI isMIDIConnectedBool ->
              ( initMidi isMIDIConnectedBool, Cmd.none )

            _ ->
              ( model, Cmd.none )

---------------------   START SCREEN   --------------------
      StartLevelScreen levelIndex ->
        case msg of

            -- TODO: Generate the notes based on levelIndex !!!

            StartGame ->
              let
                  newGameModel = { initialGameModel | levelIndex = levelIndex + 1}

                  nextGameLevel = case (Array.get newGameModel.levelIndex Const.levels) of
                    Nothing ->
                      { rootMidi = 60, maxInterval = 1 }
                    Just level ->
                      level
              in
                ( Game newGameModel
                , Random.generate GenerateTargetNotes (generateRandomTargetNotes Const.notesPerLevel nextGameLevel)
                )


            -- TODO: how to keep track of the current level though??? to generate the notes the way I want to... 

            GenerateTargetNotes midiList ->
              let
                  -- Init the NEXT game level 
                  -- NOTE: When game is first started, levelIndex will increment from 0 to 1 so the first level is actually 1
                  -- TODO: Have a button to play next level OR repeat the current ... or other actions =P
                  newGameModel =
                    { initialGameModel |
                      targetNotes =
                        Array.fromList
                          <| List.map Note.createNote midiList
                    }
              in
                ( Game newGameModel, Cmd.none )

            _ ->
              ( model, Cmd.none )

---------------------   GAME SCREEN   --------------------
      Game gameModel ->
            case msg of
      
              AnimFrame curTime ->
                let
                  newGameModel = 
                    gameModel
                      |> updateCurTime curTime
                      |> updateSprites curTime
                      |> updatePlayerPos curTime
                      |> updateScrollPos
                in
                   ( Game newGameModel, Cmd.none )


              NotePressed midiCode -> 
                let
                  newGameModel =
                    gameModel
                      |> updateCurrentNote midiCode
                      |> updateScoreAndTargetIfCorrect
                      |> updatePlayerTrajectory

                  nextModel = 
                    if (isLevelComplete newGameModel) then
                      -- Show screen with the prev level index. (Later: show recap of score etc etc)
                      StartLevelScreen newGameModel.levelIndex
                    else
                      Game newGameModel
                in
                   ( nextModel, Cmd.none )


              NoteReleased _ ->
                ( Game gameModel, Cmd.none )

              _ ->
                ( Game gameModel, Cmd.none )



updateCurTime : Time.Posix -> GameModel -> GameModel
updateCurTime curTime model =
  { model | currentTime = curTime }


-- Update index of each game sprite (currently just 2 directly in the gameModel) AND set next frame timestamp
updateSprites : Time.Posix -> GameModel -> GameModel
updateSprites curTime model =
    if (Time.posixToMillis curTime) >= (Time.posixToMillis model.nextFrameTime) then
        { model
        | playerSpriteIndex = ( remainderBy View.Player.numSpriteFrames (model.playerSpriteIndex + 1) )
        , itemSpriteIndex = ( remainderBy View.Target.numSpriteFrames (model.itemSpriteIndex + 1) )
        , nextFrameTime = 
            Time.millisToPosix 
            <| (Time.posixToMillis curTime) + Const.spriteAnimDelayMillis
        }
    else
        model


updateScrollPos : GameModel -> GameModel
updateScrollPos model =
  { model | scrollPosition = scrollTo model.scrollPosition model.nextTargetNoteIndex }


-- Exponential easing curve; Penner's "standard exponention slide"; Zeno's Paradox for animation :)
scrollTo currentPosition nextTargetNoteIndex =
  let
    targetPosition = Const.leftMargin + ((toFloat nextTargetNoteIndex) * (toFloat Const.noteXInterval))

    remainingDistance = targetPosition - currentPosition
  in
    currentPosition + (remainingDistance * Const.scrollAnimMultiplier)



-- Either continue jumping, or when jump duration is complete,
-- stick to the target position
-- *** and update jumpStartTime !
updatePlayerPos : Time.Posix -> GameModel -> GameModel
updatePlayerPos curTime ({player} as model) =
  let
    timeSinceJump = toFloat <| (Time.posixToMillis curTime) - (Time.posixToMillis player.jumpStartTime)
  in
    if timeSinceJump < model.player.jumpDurationMillis then
     { model | player =
        { player | currentPos = 
            Vector
            (Physics.getCurrentJumpXPosition player.jumpStartPos.x player.velocity.x timeSinceJump)
            (Physics.getCurrentJumpYPosition player.jumpStartPos.y player.velocity.y Const.accelYMillis timeSinceJump)
        }
      }
  else
    -- Update player to "stick" to the target position when jump anim is done
    { model | player = 
      { player | 
        currentPos = model.nextTargetPos
      }
    }




-- Update model based on MIDI event from JS
initMidi : Bool -> Model
initMidi isMIDIConnectedBool =
  let
      newModel = case isMIDIConnectedBool of
                  True -> StartLevelScreen 0
                  False -> LoadingScreen
  in
    newModel



-- Update player's velocity, jump start position, jump duration milliseconds, and jump start time
updatePlayerTrajectory : GameModel -> GameModel
updatePlayerTrajectory gameModel =
  let
    newJumpStartPos = gameModel.player.currentPos -- reset!

    newJumpDur =
      Physics.updateJumpDur gameModel.nextTargetPos gameModel.player.currentPos

    newVelocity = 
      Physics.updateVelocity newJumpStartPos gameModel.nextTargetPos newJumpDur

    curPlayer = gameModel.player
    updatedPlayer =
        { curPlayer | jumpStartPos = newJumpStartPos
        , velocity = newVelocity
        , jumpDurationMillis = newJumpDur
        , jumpStartTime = gameModel.currentTime
        }
  in
      { gameModel | player = updatedPlayer }


updateCurrentNote : Int -> GameModel -> GameModel
updateCurrentNote midiCode gameModel =
  let
      newCurrentNote = Note.createNote midiCode
  in
    { gameModel | currentNote = Just newCurrentNote }



updateScoreAndTargetIfCorrect : GameModel -> GameModel
updateScoreAndTargetIfCorrect gameModel =
  let

    currentMidiCode =
      case gameModel.currentNote of
        Nothing -> 60
        Just note -> note.midi

    nextTargetNoteMidi =
      case (Array.get gameModel.nextTargetNoteIndex gameModel.targetNotes) of
        Nothing -> 60
        Just note -> note.midi

    isCorrect = 
      case gameModel.currentNote of
          Nothing -> False
          Just currentNote ->
              if currentNote.midi == nextTargetNoteMidi then
                True
              else
                False

    newNextTargetNoteIndex =
      if isCorrect then
        gameModel.nextTargetNoteIndex + 1
      else
        gameModel.nextTargetNoteIndex


-- animation will jump to: next note, or up to incorrect note
    newTargetPos = 
        Vector
          (Note.getNoteX (newNextTargetNoteIndex - 1))
          (Note.getNoteY currentMidiCode)
  in
    { gameModel | score = gameModel.score + 1
    , nextTargetNoteIndex = newNextTargetNoteIndex
    , nextTargetPos = newTargetPos
    } 

-- NOTE: nextTargetNoteIndex only advances on playing correct note,
-- so this can only return true when playing the last correct note
isLevelComplete : GameModel -> Bool
isLevelComplete gameModel =
  let
    isComplete = 
        if gameModel.nextTargetNoteIndex >= (Array.length gameModel.targetNotes) then
           True
        else
           False
  in
    isComplete 
    -- { gameModel | levelIndex = levelIndex + 1 }


-- Generate list of [num] random midi codes
generateRandomTargetNotes : Int -> Level -> Random.Generator (List Int)
generateRandomTargetNotes listLength gameLevel =
  let
      minValue = gameLevel.rootMidi - gameLevel.maxInterval
      maxValue = gameLevel.rootMidi + gameLevel.maxInterval
  in
    Random.list listLength
      <| Random.int minValue maxValue

    -- Random.list num <| Random.uniform 60 [64, 67]
    -- Random.list num <| Random.uniform 59 [53, 54, 55, 56, 57, 58]

    -- Just checking a couple ledger lines
    -- Random.list num <| Random.uniform 81 [86, 88]


    -- BASS TO TREBLE (no ledger lines), including middle C
    -- Random.list num <| Random.uniform 41 (List.range 42 80)

    
    -- EVERYTHIIIIIING!
    -- Random.list num <| Random.uniform 21 (List.range 22 108)

{--
  Random.list num <| Random.uniform 60 [ 62
   , 64
   , 65
   , 67
   , 69
   , 71
   , 72
   , 74
   , 76
   , 77
   , 79
   ]
--}


