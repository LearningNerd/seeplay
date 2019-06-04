port module Update exposing (update)


import Dict exposing (Dict)
import Array exposing (..)
import Browser
import Random
import Tuple exposing (..)
import Task
import Time
import Json.Encode as E

import Constants
import Model exposing (Model, Score)
import Msg exposing (..)
import Note exposing (Note)
import Ports

import View.Mario


-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =

    case msg of

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

    -- Append data to scoreList if startTime has been initialized
    newScoreObjectList =
      if model.startTimestamp /= Nothing
        then [ Score model.correctNote newAnswerSpeed model.incorrectTries ]
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
       -- Temporary test:
       , testCurrentTimestamp = Just currentTimestamp
       }
     , nextCommand
     )

-- HELPERS FOR FUNCTION ABOVE:
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
-- Update score and num of incorrect guesses
updateNotePressed : Model -> Int -> ( Model, Cmd Msg )
updateNotePressed model noteCode =
  let
    prevMidi = case model.prevMidi of
      Nothing -> noteCode -- the note that was just pressed
      Just m -> m

    newCurrentNote = Note.createNote noteCode

    nextTargetNote = getNextTargetNote model.nextTargetNoteIndex model.targetNotes

    isCorrect = getIsCorrect nextTargetNote (Just newCurrentNote)
  in
    ( { model | currentNote = Just newCurrentNote
      , prevMidi = Just noteCode
      , score =
            if isCorrect then model.score + 1 else model.score
      , incorrectTries =
            if isCorrect then model.incorrectTries else model.incorrectTries + 1
      }
    , Cmd.none
    )


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

