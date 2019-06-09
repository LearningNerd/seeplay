port module Update exposing (update)


import Dict exposing (Dict)
import Array exposing (..)
import Browser
import Random
import Tuple exposing (..)
import Task
import Time
import Json.Encode as E

import ConstantsHelpers
import Model exposing (Model, Score)
import Msg exposing (..)
import Note exposing (Note)
import Ports

import View.Mario




-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =

    case msg of

        AnimFrame millisSinceLastFrame ->
          updateAnimationValues model millisSinceLastFrame

        InitMIDI isMIDIConnectedBool ->
          initMidi model isMIDIConnectedBool
        
        StartGame ->
          startGame model
       
        GenerateTargetNotes midiCodeList ->
          generateTargetNotes model midiCodeList

        RestartTimer currentTimestamp ->
          restartTimer model currentTimestamp
          
        NoteReleased _ -> (model, Cmd.none)

        NotePressed noteCode -> 
          updateNotePressed model noteCode



-- Animate (this runs roughly every 60 ms
updateAnimationValues : Model -> Float -> ( Model, Cmd Msg )
updateAnimationValues model millisSinceLastFrame =
  let
    -- update timer for jump, and for each sprite frame anim 
    newMillisSinceJumpStarted = model.millisSinceJumpStarted + millisSinceLastFrame
    
    newMillisSinceLastSpriteAnim = model.millisSinceLastSpriteAnimFrame + millisSinceLastFrame


    -- Update sprite
    newPlayerSpriteIndex = 
      if newMillisSinceLastSpriteAnim >= ConstantsHelpers.spriteAnimDelayMillis then
         ( remainderBy View.Mario.numSpriteFrames (model.playerSpriteIndex + 1) )
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
        }

    -- Only update player position for duration of jump
    -- (this is so it doesn't animate past the target)
    updatedModel =
        if newMillisSinceJumpStarted < ConstantsHelpers.jumpDurationMillis then
          updateModelContinueJumping updatedModelBase
        else
          updateModelStopJumping updatedModelBase
  in
     ( updatedModel, Cmd.none )


-- Animation helpers for above...

-- Subtract current timestamp

-- Function to update model with current player position
updateModelContinueJumping model =
  { model | playerCurrentXPosition =
        ConstantsHelpers.getCurrentJumpXPosition model.playerJumpStartXPosition model.velocityX model.millisSinceJumpStarted

  , playerCurrentYPosition =
        Debug.log "currentYPos " (ConstantsHelpers.getCurrentJumpYPosition model.playerJumpStartYPosition model.velocityY ConstantsHelpers.accelYMillis model.millisSinceJumpStarted)
  }

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
-- and update state to show game can now be played, if so
initMidi : Model -> Bool -> ( Model, Cmd Msg )
initMidi model isMIDIConnectedBool =
  let
      isPlaying =
        if model.isPlaying && isMIDIConnectedBool == False
          then False
          else model.isPlaying
  in
    ( { model |
      isMIDIConnected = Just isMIDIConnectedBool
      , isPlaying = isPlaying
      }
    , Cmd.none
    )


-- Initiate timer!
startGame : Model -> ( Model, Cmd Msg )
startGame model =
     ( { model |
       isPlaying = True
       }
     , Task.perform RestartTimer Time.now 
     )


-- On page load, and triggered by .....:
-- initialize array from the given list of randomized MIDI code integers
-- animate player onto the first note ??
generateTargetNotes : Model -> List Int -> ( Model, Cmd Msg )
generateTargetNotes model midiCodeList =
  let
      targetNotes = Array.fromList (List.map Note.createNote midiCodeList)
  in
     ( { model | targetNotes = targetNotes }
     , Cmd.none
     )


-- Initialize timer when user starts the game
-- and restart timer after every correct answer
-- Cache this data in local storage
-- restartTimer : Model -> List Int -> ( Model, Cmd Msg )
restartTimer model currentTimestamp =
  let
    newAnswerSpeed =
      getNewAnswerSpeed model.startTimestamp currentTimestamp


    correctNote = getCurrentCorrectNote model.nextTargetNoteIndex model.targetNotes

    -- Append data to scoreList if startTime has been initialized
    newScoreObjectList =
      if model.startTimestamp /= Nothing
        then [ Score correctNote newAnswerSpeed model.incorrectTries ]
        else []

    -- Only save to local storage if this is NOT the very first note displayed
    nextCommand =
      if model.startTimestamp /= Nothing
        then Cmd.batch [
          Ports.saveLocalData (E.list convertScoreToJSON
                  (model.scoreList ++ newScoreObjectList)
                )
          ]
      else Cmd.none
  in
     ( { model | answerSpeed = newAnswerSpeed
       , scoreList = model.scoreList ++ newScoreObjectList
       -- Always update start time:
       , startTimestamp = Just currentTimestamp
       -- RESET after getting it correct (and command below will send OLD value, not the new one):
       , incorrectTries = 0
       }
     , nextCommand
     )


-- HELPERS FOR FUNCTION ABOVE:
 
getCurrentCorrectNote index arr =
  let
    maybeCorrectNote = Array.get index arr
  in
    case maybeCorrectNote of
      Nothing ->
        Note.createNote 60 -- temporary fix =P last note is always C4 ?
      Just correctNote ->
        correctNote


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
updateNotePressed : Model -> Int -> ( Model, Cmd Msg )
updateNotePressed model noteCode =
  let
    prevMidi = case model.prevMidi of
      Nothing -> noteCode -- the note that was just pressed
      Just m -> m

    newCurrentNote = Note.createNote noteCode

    nextTargetNote = getNextTargetNote model.nextTargetNoteIndex model.targetNotes

    updatedModelBase =
      { model | currentNote = Just newCurrentNote
      , prevMidi = Just noteCode
      }

    isCorrect = getIsCorrect nextTargetNote (Just newCurrentNote)

    updatedModel = 
      if isCorrect then
        updateForCorrectNote updatedModelBase nextTargetNote.midi
      else
        updateForIncorrectNote updatedModelBase
  in
    ( updatedModel
    , Cmd.none
    )


updateForIncorrectNote model =
    { model | incorrectTries = model.incorrectTries + 1 }


updateForCorrectNote model nextTargetNoteMidiCode =
  let
    newPlayerJumpStartXPosition = model.playerCurrentXPosition
    newPlayerJumpStartYPosition = model.playerCurrentYPosition

    newNextTargetXPosition = ConstantsHelpers.getNoteXPos model.nextTargetNoteIndex
    newNextTargetYPosition = ConstantsHelpers.getNoteYPos nextTargetNoteMidiCode
  in
      { model | score = model.score + 1
      , nextTargetNoteIndex = model.nextTargetNoteIndex + 1

      , playerJumpStartXPosition = newPlayerJumpStartXPosition
      , playerJumpStartYPosition = newPlayerJumpStartYPosition

      , nextTargetXPosition = newNextTargetXPosition
      , nextTargetYPosition = newNextTargetYPosition

      , velocityX = 
          ConstantsHelpers.getRequiredXVelocity newPlayerJumpStartXPosition newNextTargetXPosition ConstantsHelpers.jumpDurationMillis

      , velocityY = 
          ConstantsHelpers.getRequiredYVelocity newPlayerJumpStartYPosition newNextTargetYPosition ConstantsHelpers.accelYMillis ConstantsHelpers.jumpDurationMillis

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

