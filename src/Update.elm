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

import ConstantsHelpers
import Model exposing (Model(..), GameModel, initialGameModel)
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
              ( model, Random.generate GenerateTargetNotes (Note.getRandomMidiList ConstantsHelpers.notesPerLevel) )

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

              NotePressed noteCode -> 
                updateNotePressed gameModel noteCode

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
      if newMillisSinceLastSpriteAnim >= ConstantsHelpers.spriteAnimDelayMillis then
         ( remainderBy View.Player.numSpriteFrames (model.playerSpriteIndex + 1) )
      else
        model.playerSpriteIndex -- don't change otherwise


    -- Update coin sprite
    newItemSpriteIndex = 
      if newMillisSinceLastSpriteAnim >= ConstantsHelpers.spriteAnimDelayMillis then
         ( remainderBy View.Target.numSpriteFrames (model.itemSpriteIndex + 1) )
      else
        model.playerSpriteIndex -- don't change otherwise


          ------- should refactor this =P
    -- Update timer for sprite animation
    newNewMillisSinceLastSpriteAnim = 
      if newMillisSinceLastSpriteAnim >= ConstantsHelpers.spriteAnimDelayMillis then
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
        if newMillisSinceJumpStarted < model.jumpDurationMillis then
          updateModelContinueJumping updatedModelBase
        else
          updateModelStopJumping updatedModelBase
  in
     updatedModel


-- Animation helpers for above...

-- Subtract current timestamp

-- Function to update model with current player position
updateModelContinueJumping model =
  { model | playerCurrentXPosition =
        ConstantsHelpers.getCurrentJumpXPosition model.playerJumpStartXPosition model.velocityX model.millisSinceJumpStarted

  , playerCurrentYPosition =
        ConstantsHelpers.getCurrentJumpYPosition model.playerJumpStartYPosition model.velocityY ConstantsHelpers.accelYMillis model.millisSinceJumpStarted
  }

-- Update player to "stick" to the target position when animation is done
updateModelStopJumping model =
  { model | playerCurrentXPosition = model.nextTargetXPosition        
  , playerCurrentYPosition = model.nextTargetYPosition
  }


-- Exponential easing curve; Penner's "standard exponention slide"; Zeno's Paradox for animation :)
scrollTo currentPosition nextTargetNoteIndex =
  let
    targetPosition = ConstantsHelpers.leftMargin + ((toFloat nextTargetNoteIndex) * (toFloat ConstantsHelpers.noteXInterval))

    remainingDistance = targetPosition - currentPosition
  in
    currentPosition + (remainingDistance * ConstantsHelpers.scrollAnimMultiplier)




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



-- Edge case: starting the timer when game begins shouldn't update answerSpeed
getNewAnswerSpeed startTime currentTime =
  case startTime of
    Nothing ->
        0
    Just t ->
        (Time.posixToMillis currentTime) - (Time.posixToMillis t)

-- Convert Score record into a JSON object Value type
convertScoreToJSON session =
  E.object [ ("correctNoteMidi", E.int session.correctNote.midi)
  , ("answerSpeed", E.int session.answerSpeed)
  , ("incorrectTries", E.int session.incorrectTries)
  ]



-- Update state for previously played note,
-- for currently pressed note,
-- for next target note
-- Check if note is correct!
    -- if so, scroll anim
-- Update score and num of incorrect guesses
updateNotePressed : GameModel -> Int -> GameModel
updateNotePressed model noteCode =
  let
    prevMidi = case model.prevMidi of
      Nothing -> noteCode -- the note that was just pressed
      Just m -> m

    -- Get info for the note that's just been pressed
    newCurrentNote = Note.createNote noteCode

    -- Get info for the next target note, also to check if correct or not
    nextTargetNote = getNextTargetNote model.nextTargetNoteIndex model.targetNotes

    -- Always update the current note that was pressed, and the previous note
    updatedModelBase =
      { model | currentNote = Just newCurrentNote
      , prevMidi = Just noteCode -- <<<<< wait, this seems wrong =/ fix it later
      }

    -- Check if correct note! and update the model differently for correct/incorrect (see below)
    isCorrect = getIsCorrect nextTargetNote (Just newCurrentNote)

    updatedModel = 
      if isCorrect then
        updateForCorrectNote updatedModelBase nextTargetNote.midi
      else
        updateForIncorrectNote updatedModelBase noteCode
  in
    updatedModel


-- If correct: increase score
-- and update target etc etc to jump to the next target (which becomes the current position of the player after hte jump animation)
updateForCorrectNote model nextTargetNoteMidiCode =
  let
    newPlayerJumpStartXPosition = model.playerCurrentXPosition
    newPlayerJumpStartYPosition = model.playerCurrentYPosition

    newNextTargetXPosition = ConstantsHelpers.getNoteXPos model.nextTargetNoteIndex
    newNextTargetYPosition = ConstantsHelpers.getNoteYPos nextTargetNoteMidiCode

    newJumpDurationMillis = ConstantsHelpers.convertFramesToMillisDuration ConstantsHelpers.defaultJumpDurationFrames ConstantsHelpers.framesPerSecond

  in
      { model | score = model.score + 1
      , nextTargetNoteIndex = model.nextTargetNoteIndex + 1

      , playerJumpStartXPosition = newPlayerJumpStartXPosition
      , playerJumpStartYPosition = newPlayerJumpStartYPosition

      , nextTargetXPosition = newNextTargetXPosition
      , nextTargetYPosition = newNextTargetYPosition

      , velocityX = 
          ConstantsHelpers.getRequiredXVelocity newPlayerJumpStartXPosition newNextTargetXPosition newJumpDurationMillis

      , velocityY = 
          ConstantsHelpers.getRequiredYVelocity newPlayerJumpStartYPosition newNextTargetYPosition ConstantsHelpers.accelYMillis newJumpDurationMillis

      , jumpDurationMillis = newJumpDurationMillis
      , millisSinceJumpStarted = 0
      }


-- If incorrect: increase num of incorrect tries
-- and update next target to be at the new Y position, to jump up/down (but not advancing in the game level)
updateForIncorrectNote model incorrectMidiCodeJustPressed =
  let
    newPlayerJumpStartXPosition = model.playerCurrentXPosition
    newPlayerJumpStartYPosition = model.playerCurrentYPosition

    newNextTargetYPosition = ConstantsHelpers.getNoteYPos incorrectMidiCodeJustPressed

    distanceToJumpY = Debug.log "distanceToJumpY " (abs (newNextTargetYPosition - model.playerCurrentYPosition))

    multiplyJumpBy = Debug.log "multiplyJumpBy " (distanceToJumpY/ConstantsHelpers.svgViewHeight)

    newJumpDurFrames = Debug.log " newJumpDurFrames " <| ConstantsHelpers.minJumpDurationFrames + ConstantsHelpers.baseJumpDurationFrames * multiplyJumpBy

    newJumpDurationMillis = ConstantsHelpers.convertFramesToMillisDuration newJumpDurFrames ConstantsHelpers.framesPerSecond

  in
      { model | incorrectTries = model.incorrectTries + 1

      , playerJumpStartXPosition = newPlayerJumpStartXPosition
      , playerJumpStartYPosition = newPlayerJumpStartYPosition

      , nextTargetYPosition = newNextTargetYPosition
{--
      , velocityX = 
           ConstantsHelpers.getRequiredXVelocity newPlayerJumpStartXPosition newNextTargetXPosition temporaryJumpDurationMillis

      , velocityY = 
          ConstantsHelpers.getRequiredYVelocity newPlayerJumpStartYPosition newNextTargetYPosition ConstantsHelpers.accelYMillis temporaryJumpDurationMillis
--}

      , velocityX = 
           ConstantsHelpers.getRequiredXVelocity newPlayerJumpStartXPosition model.nextTargetXPosition newJumpDurationMillis

      , velocityY = 
          ConstantsHelpers.getRequiredYVelocity newPlayerJumpStartYPosition newNextTargetYPosition ConstantsHelpers.accelYMillis newJumpDurationMillis
     
      , jumpDurationMillis = newJumpDurationMillis
      , millisSinceJumpStarted = 0
      }




getNextTargetNote index targetNotesArray = 
  let 
      next = Array.get index targetNotesArray
  in
    case next of
      Nothing -> Note.createNote 60 -- temporary fix =P last note is always C4 ?
      Just n -> n


getIsCorrect : Note -> Maybe Note -> Bool
getIsCorrect correctNote currentNote = 
    case currentNote of
      Nothing -> False
      Just n ->
        if n.midi == correctNote.midi then
          True
        else
          False

