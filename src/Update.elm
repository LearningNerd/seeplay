port module Update exposing (update)


import Dict exposing (Dict)
import Array exposing (..)
import Browser
import Random
import Tuple exposing (..)
import Task
import Time
import Json.Encode as E
import Animation
import Animation.Messenger

import Helpers exposing (..)
import Constants
import Model exposing (Model, Score)
import Animations
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

        MoveToCoinDone ->
          moveToCoinDone model

        GetCoinDone ->
          getCoinDone model

        Animate timestamp -> 
          animate model timestamp

--------------------- NOT BEING USED RIGHT NOW -------------
        StartScrollGameLevel ->
          let
              currentScrollState = getUniqueAnimState model.uniqueAnimStates Constants.scrollState
              newScrollState = Animation.interrupt [Animations.scrollGameLevel model.nextTargetNoteIndex] currentScrollState
          in
            -- ( { model | gameLevelScrollState = Animation.interrupt [Animations.scrollGameLevel model.nextTargetNoteIndex] model.gameLevelScrollState }
            (
            { model | uniqueAnimStates = Helpers.updateUniqueAnimState model.uniqueAnimStates (Constants.scrollState, newScrollState) }
            , Cmd.none
            )


        TestTick currentTimestamp ->
          ( { model | testCurrentTimestamp = Just currentTimestamp }
          , Cmd.none
          )
------------------------------------------------------------



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


-- Start Mario walk anim sprite
-- Start animating every note sprite
-- Initiate timer!
startGame : Model -> ( Model, Cmd Msg )
startGame model =
  let
    currentMarioSpriteStyle =
      getUniqueAnimState model.uniqueAnimStates Constants.currentNoteStyle
      
    newMarioSprite =
      Animation.interrupt View.Mario.marioWalkLoop currentMarioSpriteStyle
     
    updatedUniqueAnimStates =
      Helpers.updateUniqueAnimState model.uniqueAnimStates (Constants.currentNoteStyle, newMarioSprite)

  in
     ( { model |
       isPlaying = True
       , targetNotes = Helpers.startAnimEveryNote model.targetNotes Animations.coinLoop
       , uniqueAnimStates = updatedUniqueAnimStates
       }
     , Task.perform RestartTimer Time.now 
     )


-- On page load, and triggered by .....:
-- initialize array from the given list of randomized MIDI code integers
generateTargetNotes : Model -> List Int -> ( Model, Cmd Msg )
generateTargetNotes model midiCodeList =
  let
      targetNotes = Array.fromList (List.map Note.createNote midiCodeList)
      -- test = Debug.log "targetnotes: " targetNotes
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
-- Update animation with jump/fall (or continue walking) as needed
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
    
    nextAnimStepsList = jumpOrFall prevMidi noteCode

    currentMarioSpriteStyle = getUniqueAnimState model.uniqueAnimStates Constants.currentNoteStyle
    
    -- for now, only use jump/fall sprites when getting correct note. but this isn't what I actually want =P let's test this first!
    newMarioStyle = if isCorrect
        then
            nextAnimStepsList currentMarioSpriteStyle
        else
            Animation.interrupt View.Mario.marioWalkLoop currentMarioSpriteStyle
    
    newUniqueAnimStates = Helpers.updateUniqueAnimState model.uniqueAnimStates (Constants.currentNoteStyle, newMarioStyle)

  in
    ( { model | currentNote = Just newCurrentNote
      , prevMidi = Just noteCode
      , score =
            if isCorrect then model.score + 1 else model.score
      , incorrectTries =
            if isCorrect then model.incorrectTries else model.incorrectTries + 1
      , uniqueAnimStates = newUniqueAnimStates
      }
    -- , nextCommand
    , Cmd.none
    )

-- HELPERS FOR THE ABOVE FUNCTION:
    -- need to handle case where note is at same level ... stay a bit in front of note, not directly on it? or just never have two same notes in a row?
jumpOrFall prevMidi currentMidi =
  if currentMidi > prevMidi
     then Animation.interrupt ( View.Mario.marioJump currentMidi )
     else Animation.interrupt ( View.Mario.marioFall currentMidi )

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


----- TRIGGERED BY ANIMATIONS ENDING ------

-- Make coin disappear after Mario has reached a coin.
-- TRIGGERS GetCoinDone ...
moveToCoinDone : Model -> ( Model, Cmd Msg )
moveToCoinDone model =
  let
    maybeTargetNote = Array.get model.nextTargetNoteIndex model.targetNotes

    nextTargetNote = case maybeTargetNote of
        Nothing -> Note.createNote 60 -- ...not sure what other fallback =P
        Just n -> n

    coinAnimSteps =
      Animation.interrupt Animations.coinDisappear nextTargetNote.animState

    updatedTargetNote =
      { nextTargetNote | animState = coinAnimSteps }

    allUpdatedTargetNotes =
      Array.set model.nextTargetNoteIndex updatedTargetNote model.targetNotes

  in
     ( { model | targetNotes = allUpdatedTargetNotes }
       , Cmd.none 
     )


-- ** this only gets triggered if a correct note was just played
-- Resume walk sprite,
-- move mario x pos
-- scroll to next note.
-- Update model with next note index
getCoinDone : Model -> ( Model, Cmd Msg )
getCoinDone model =
  let
    -- Update next target note in model, scroll game level to next note
    newNextTargetNoteIndex = model.nextTargetNoteIndex + 1

    -- move mario x pos to the next note!
    currentMarioContainerPos =
      getUniqueAnimState model.uniqueAnimStates Constants.marioContainer

    newMarioPos = Animation.interrupt 
      [ Animation.toWith Animations.scrollAndWalkEasing
        [ Animation.x (View.Mario.getMarioXPosition newNextTargetNoteIndex)]
      ] currentMarioContainerPos

    newMarioPosState =
      Helpers.updateUniqueAnimState model.uniqueAnimStates (Constants.marioContainer, newMarioPos)

    -- update mario to resume walk cycle
    currentMarioSpriteStyle =
      getUniqueAnimState model.uniqueAnimStates Constants.currentNoteStyle

    newMarioSprite =
      Animation.interrupt View.Mario.marioWalkLoop currentMarioSpriteStyle

    newMarioSpriteAndPosState =
      Helpers.updateUniqueAnimState newMarioPosState  (Constants.currentNoteStyle, newMarioSprite)

    -- update game level scroll anim
    currentScrollState = getUniqueAnimState model.uniqueAnimStates Constants.scrollState

    newScrollState =
      Animation.interrupt [ Animations.scrollGameLevel model.nextTargetNoteIndex] currentScrollState

    newUniqueAnimStates =
      Helpers.updateUniqueAnimState newMarioSpriteAndPosState (Constants.scrollState, newScrollState)

  in
     ( { model | nextTargetNoteIndex = newNextTargetNoteIndex
       , uniqueAnimStates = newUniqueAnimStates
       }
     , Cmd.none
     )


-- Update every animation stored in the model (in a dictionary)
-- and extract all the next commands to run
-- And do the same with the array of notes (each note has an anim style)
animate model timestamp =
  let
    updatedDict = updateEveryAnimState model.uniqueAnimStates timestamp

    uniqueElemAnimCmds = List.map Tuple.second (Dict.values updatedDict)

    dictStylesOnly = Dict.map (\key val -> Tuple.first val) updatedDict

    (newNotes, noteAnimCmds) =
      List.unzip (List.map (Helpers.updateNoteWithAnimState timestamp) (Array.toList model.targetNotes))
  in
     ( { model | uniqueAnimStates = dictStylesOnly
       , targetNotes = Array.fromList newNotes
       }
     , Cmd.batch (uniqueElemAnimCmds ++ noteAnimCmds)
     )

