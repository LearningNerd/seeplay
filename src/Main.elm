port module Main exposing (..)


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
import Html exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)

import Helpers exposing (..)
import Constants
import Model exposing (Model, Score, initialModel)
import Color
import Animations
import Msg exposing (..)
import Note exposing (Note)

import View.Header
import View.MidiStatus
import View.StartScreen
import View.Game
-- TEST:
import View.Coin

port handleInitMIDI : (Bool -> msg) -> Sub msg
port handleNotePressed : (Int -> msg) -> Sub msg
port handleNoteReleased : (Bool -> msg) -> Sub msg


port cache : E.Value -> Cmd msg


-- Fake data from fakemidi.js (manual testing in browser)
port fakeHandleInitMIDI : (Bool -> msg) -> Sub msg
port fakeHandleNotePressed : (Int -> msg) -> Sub msg
port fakeHandleNoteReleased : (Bool -> msg) -> Sub msg




-- TIME HELPER...
displayTimestamp timestamp =
  case timestamp of
        Nothing -> "EMPTY"
        Just t -> String.fromInt (Time.posixToMillis t)

getMillis timestamp =
  case timestamp of
        Nothing -> 0
        Just t -> Time.posixToMillis t



-- VIEW


view : Model -> Html Msg
view model =
    div [ ]
        [ View.Header.view model
        , main_ [A.class "container"] [ Html.p [onClick StartScrollGameLevel ] [ Html.text "....???? test!"] , case model.isMIDIConnected of
            -- If Nothing or False (waiting to init or no MIDI available), then show the MidiStatus screen (waiting for input)
            Nothing ->
              View.MidiStatus.view model
              -- View.Coin.view model
              -- View.Game.view model


            Just False ->
              View.MidiStatus.view model

            Just True ->
              if model.isPlaying
                 then View.Game.view model
                 else View.StartScreen.view model
           ] -- end main 
        ]


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =

    case msg of

        InitMIDI isMIDIConnectedBool ->
            ( { model | isMIDIConnected = Just isMIDIConnectedBool
              , isPlaying = if model.isPlaying && isMIDIConnectedBool == False
                               then
                                  False
                               else
                                  model.isPlaying
              }
            , Cmd.none
            )


        -- don't draw notes when they're not being held down
        NoteReleased _ ->
          let
            newAnimSteps = [ Animation.wait (Time.millisToPosix 50)
              , Animation.to [ Animation.opacity 0.0 ]
              , Animation.Messenger.send (CurrentNoteFadeAnimCompleted)
              ]
          in
            ( updateModelForUniqueAnim model Constants.currentNoteStyle newAnimSteps
            , Cmd.none
            )


        CurrentNoteFadeAnimCompleted ->
          let
              test = Debug.log "hiiii" "CurrentNoteFadeAnimCompleted"
          in
            ( { model | currentNote = Nothing }, Cmd.none )



        NotePressed noteCode -> updateNotePressed noteCode model



        CorrectNoteFadeAnimCompleted ->
          let
              newAnimSteps = [Animation.to [ Animation.opacity 0.0, Animation.fill Color.black ] ]
          in
            ( updateModelForUniqueAnim model Constants.correctNoteStyle newAnimSteps
            , Task.perform RestartTimer Time.now
            )



        StartGame ->
            ( { model | isPlaying = True
              , targetNotes = Helpers.startAnimEveryNote model.targetNotes Animations.coinLoop
              }
            , Task.perform RestartTimer Time.now 
            )



-- called when page loads to initialize correctNote, and again on each correct note played!
        GenerateTargetNotes midiCodeList ->
          let
            targetNotes = Array.fromList (List.map Note.createNote midiCodeList)
            test = Debug.log "targetnotes: " targetNotes
          in
            ( { model | targetNotes = targetNotes -- List.map Note.createNote midiCodeList
              -- update model to track animation state for each generated note!!
              }
            , Cmd.none
            )
 


        UpdateCorrectNote midiCode ->
          let
              newAnimSteps = [ Animation.to [ Animation.opacity 1.0] ]
          in
             ( updateModelForUniqueAnim model Constants.correctNoteStyle newAnimSteps
             , Cmd.none
             )



        RestartTimer currentTimestamp ->
          let
            newAnswerSpeed = getNewAnswerSpeed model.startTimestamp currentTimestamp
            newScoreObjectList = if model.startTimestamp /= Nothing
                                 then [ Score model.correctNote newAnswerSpeed model.incorrectTries ]
                                 else [] -- don't append to score list  if this is the FIRST note of the session

            -- only save to local storage if this is NOT the very first note displayed
            nextCommand = if model.startTimestamp /= Nothing
                              then 
                                Cmd.batch [ cache (E.list convertScoreToJSON (model.scoreList ++ newScoreObjectList) )
                                -- , Random.generate UpdateCorrectNote Note.getRandomMidi
                                ]
                              else Cmd.none
          in
            ( { model
                 | answerSpeed = newAnswerSpeed
                  , startTimestamp = Just currentTimestamp -- always update start time
                  , testCurrentTimestamp = Just currentTimestamp
                  , scoreList = model.scoreList ++ newScoreObjectList
                  , incorrectTries = 0 -- RESET after getting it correct (and command below will send OLD value, not the new one)
              }
            , nextCommand
            )



        -- UPDATE EVERY ANIMATED ELEMENT
        Animate timestamp ->
          let
              updatedDict = updateEveryAnimState model.uniqueAnimStates timestamp
              
              uniqueElemAnimCmds = List.map Tuple.second (Dict.values updatedDict)
              
              dictStylesOnly = Dict.map (\key val -> Tuple.first val) updatedDict
              
              (newNotes, noteAnimCmds) = List.unzip (List.map (Helpers.updateNoteWithAnimState timestamp) (Array.toList model.targetNotes))
          in
              ( { model
                  | uniqueAnimStates = dictStylesOnly
                  , targetNotes = Array.fromList newNotes
                }
              , Cmd.batch (uniqueElemAnimCmds ++ noteAnimCmds)
              )



        TestTick currentTimestamp ->
          ( { model | testCurrentTimestamp = Just currentTimestamp }
          , Cmd.none
          )


-- --------- -------- test ----------------- ------
{--
        StartSpriteTestAnim ->
          let
              test = Debug.log "called StartSpriteTestAnim section of update" model.coinStyle
          in
            ( { model | coinStyle = Animation.interrupt [Animations.coinLoop] model.coinStyle }
            , Cmd.none
            )
--}


        StartScrollGameLevel ->
          let
              currentScrollState = getUniqueAnimState model.uniqueAnimStates Constants.scrollState
              newScrollState = Animation.interrupt [Animations.scrollGameLevel model.nextTargetNoteIndex] currentScrollState
          in
            -- ( { model | gameLevelScrollState = Animation.interrupt [Animations.scrollGameLevel model.nextTargetNoteIndex] model.gameLevelScrollState }
            (
            { model | uniqueAnimStates = updateUniqueAnimState model.uniqueAnimStates (Constants.scrollState, newScrollState) }
            , Cmd.none
            )


updateNotePressed noteCode model =
  let
    newCurrentNote = Note.createNote noteCode
    nextTargetNote = getNextTargetNote model.nextTargetNoteIndex model.targetNotes
    isCorrect = getIsCorrect nextTargetNote (Just newCurrentNote)
    
    newNextTargetNoteIndex = if isCorrect then (model.nextTargetNoteIndex + 1) else model.nextTargetNoteIndex

    test = Debug.log "new next target note index: " newNextTargetNoteIndex
   
    currentNoteStyle = getUniqueAnimState model.uniqueAnimStates Constants.currentNoteStyle
    newCurrentNoteStyle = if isCorrect
        then
            Animations.initialCurrentNoteStyle
        else
            Animation.interrupt [ Animation.set [Animation.opacity 0.0 ]
                                , Animation.to [ Animation.opacity 0.4 ]
                                ]
                                currentNoteStyle

    currentScrollState = getUniqueAnimState model.uniqueAnimStates Constants.scrollState
    newScrollState = Animation.interrupt [
          Animations.scrollGameLevel newNextTargetNoteIndex
          ] currentScrollState
  
    -- test2 = Debug.log "new scroll anim state: " newScrollState
    
    newUniqueAnimStates = updateUniqueAnimState model.uniqueAnimStates (Constants.currentNoteStyle, newCurrentNoteStyle)
    -- yeah..... this is terrible =P 
    newUniqueAnimStates2 = updateUniqueAnimState newUniqueAnimStates (Constants.scrollState, newScrollState)
    -- newUniqueAnimStates2 = updateUniqueAnimState model.uniqueAnimStates ("gameLevelScrollState", newScrollState)

  in
    ( { model
        | currentNote =
            Just newCurrentNote
        , nextTargetNoteIndex = newNextTargetNoteIndex
        , score =
            if isCorrect then model.score + 1 else model.score
        , incorrectTries =
            if isCorrect then model.incorrectTries else model.incorrectTries + 1
        , uniqueAnimStates = newUniqueAnimStates2
      }

    -- , nextCommand
    , Cmd.none
    )




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


getNextTargetNote index targetNotesArray = 
  let 
      next = Array.get index targetNotesArray
  in
    case next of
      Nothing -> Note.createNote 60 -- temporary fix =P last note is always C4 ?
      Just n -> n

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ handleInitMIDI InitMIDI
        , handleNotePressed NotePressed
        , handleNoteReleased NoteReleased
        , Time.every 10 TestTick -- every 10 ms
        -- ************************************************
        -- Fake data from fakemidi.js for manual testing:
        -- ************************************************
        , fakeHandleInitMIDI InitMIDI
        , fakeHandleNotePressed NotePressed
        , fakeHandleNoteReleased NoteReleased
        
        , Animation.subscription Animate ( (Dict.values model.uniqueAnimStates) ++ (List.map .animState (Array.toList model.targetNotes)))
        ]



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

init : Int -> ( Model, Cmd Msg )
init initialSessionId =
    -- Get session ID from JS flag (starts at 0, or incremented from localstorage)
    -- Generate list of random numbers
  ( { initialModel | sessionId = initialSessionId }
    , Random.generate GenerateTargetNotes (Note.getRandomMidiList Constants.notesPerLevel)
  )



updateScore : Int -> Note -> Note -> ( Int, Bool )
updateScore score correctNote currentNote =
    if currentNote.midi == correctNote.midi then
        ( score + 1, True )
    else
        ( score, False )

getIsCorrect : Note -> Maybe Note -> Bool
getIsCorrect correctNote currentNote = 
    case currentNote of
      Nothing -> False
      Just n ->
        if n.midi == correctNote.midi then
          True
        else
          False

