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
      
              AnimFrame millisSinceLastFrame ->
                updateAnimationValues gameModel millisSinceLastFrame




              NotePressed midiCode -> 
                gameModel
                  |> updateCurrentNote midiCode
                  |> updateScoreAndTargetIfCorrect
                  |> updatePlayerTrajectory
                  |> resetJumpTimer

              NoteReleased _ ->
                gameModel

              _ ->
                gameModel
        in
          ( Game newGameModel, Cmd.none )






-- Animate (this runs roughly every 60 ms
updateAnimationValues : GameModel -> Float -> GameModel
updateAnimationValues model millisSinceLastFrame =
  let
    -- update timer for jump, and for each sprite frame anim 
    newMillisSinceJumpStarted = model.millisSinceJumpStarted + millisSinceLastFrame
    
    newMillisSinceLastSpriteAnim = model.millisSinceLastSpriteAnimFrame + millisSinceLastFrame


    -- Update player sprite
    newPlayerSpriteIndex = 
      if newMillisSinceLastSpriteAnim >= Const.spriteAnimDelayMillis then
         ( remainderBy View.Player.numSpriteFrames (model.playerSpriteIndex + 1) )
      else
        model.playerSpriteIndex -- don't change otherwise


    -- Update coin sprite
    newItemSpriteIndex = 
      if newMillisSinceLastSpriteAnim >= Const.spriteAnimDelayMillis then
         ( remainderBy View.Target.numSpriteFrames (model.itemSpriteIndex + 1) )
      else
        model.playerSpriteIndex -- don't change otherwise


          ------- should refactor this =P
    -- Update timer for sprite animation
    newNewMillisSinceLastSpriteAnim = 
      if newMillisSinceLastSpriteAnim >= Const.spriteAnimDelayMillis then
         0 -- reset when it's time to update the sprite
      else
        model.millisSinceLastSpriteAnimFrame + millisSinceLastFrame -- keep countin



    -- Always update time since jump started, since last sprite anim, and scroll position
    updatedModelBase =
        { model | millisSinceJumpStarted = newMillisSinceJumpStarted
        , millisSinceLastSpriteAnimFrame = newNewMillisSinceLastSpriteAnim
        , scrollPosition = scrollTo model.scrollPosition model.nextTargetNoteIndex
        , playerSpriteIndex = newPlayerSpriteIndex
        , itemSpriteIndex = newItemSpriteIndex
        }

    -- Only update player position for duration of jump
    -- (this is so it doesn't animate past the target)
    updatedModel =
        if newMillisSinceJumpStarted < model.player.jumpDurationMillis then
          updateModelContinueJumping updatedModelBase
        else
          updateModelStopJumping updatedModelBase
  in
     updatedModel




-- Function to update model with current player position
updateModelContinueJumping model =
  let
      curPlayer = model.player

      newCurPos = 
        Vector
        (Physics.getCurrentJumpXPosition curPlayer.jumpStartPos.x curPlayer.velocity.x model.millisSinceJumpStarted)
        (Physics.getCurrentJumpYPosition curPlayer.jumpStartPos.y curPlayer.velocity.y Const.accelYMillis model.millisSinceJumpStarted)

      newPlayer = { curPlayer | currentPos = newCurPos }
  in
      { model | player = newPlayer }





-- Update player to "stick" to the target position when animation is done
updateModelStopJumping model =
  let
      curPlayer = model.player
      newPlayer = { curPlayer | currentPos = model.nextTargetPos }
  in
      { model | player = newPlayer }



-- Exponential easing curve; Penner's "standard exponention slide"; Zeno's Paradox for animation :)
scrollTo currentPosition nextTargetNoteIndex =
  let
    targetPosition = Const.leftMargin + ((toFloat nextTargetNoteIndex) * (toFloat Const.noteXInterval))

    remainingDistance = targetPosition - currentPosition
  in
    currentPosition + (remainingDistance * Const.scrollAnimMultiplier)




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


-- Update player's velocity, jump start position, jump duration milliseconds
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
        }
  in
      { gameModel | player = updatedPlayer }


resetJumpTimer : GameModel -> GameModel
resetJumpTimer gameModel =
  { gameModel | millisSinceJumpStarted = 0 } 


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


