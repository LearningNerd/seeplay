port module Update exposing (update)


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
      StartScreen ->
        case msg of

            StartGame ->
              ( model, Random.generate GenerateTargetNotes (Note.getRandomMidiList Const.notesPerLevel) )

            GenerateTargetNotes midiCodeList ->
              ( Game (generateTargetNotes initialGameModel midiCodeList), Cmd.none )

            _ ->
              ( model, Cmd.none )


---------------------   GAME SCREEN   --------------------
      Game gameModel ->
        let
          newGameModel = 
            case msg of
      
              AnimFrame curTime ->
                gameModel
                  |> updateCurTime curTime
                  |> updateSprites curTime
                  |> updatePlayerPos curTime
                  |> updateScrollPos

              NotePressed midiCode -> 
                gameModel
                  |> updateCurrentNote midiCode
                  |> updateScoreAndTargetIfCorrect
                  |> updatePlayerTrajectory


              NoteReleased _ ->
                gameModel

              _ ->
                gameModel
        in
          ( Game newGameModel, Cmd.none )



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
                  True -> StartScreen
                  False -> LoadingScreen
  in
    newModel



-- On page load, and triggered by .....:
-- initialize array from the given list of randomized MIDI code integers
-- animate player onto the first note ??
generateTargetNotes : GameModel -> List Int -> GameModel
generateTargetNotes model midiCodeList =
  let
      targetNotes = Array.fromList (List.map Note.createNote midiCodeList)
  in
     { model | targetNotes = targetNotes }


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
          (Const.getNoteXPos (newNextTargetNoteIndex - 1))
          (Const.getNoteYPos currentMidiCode)
  in
    { gameModel | score = gameModel.score + 1
    , nextTargetNoteIndex = newNextTargetNoteIndex
    , nextTargetPos = newTargetPos
    } 


