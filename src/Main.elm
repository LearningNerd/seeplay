port module Main exposing (..)

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

import Config
import Model exposing (Model, Score, initialModel)
import Color
import Animations
import Msg exposing (..)
import Note exposing (Note)
import UpdateAnimations

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
        , main_ [A.class "container"] [ Html.p [onClick StartScrollGameLevel ] [ Html.text " click me to scroll the game level!"] , case model.isMIDIConnected of
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
          ( { model | -- currentNote = Nothing
           currentNoteStyle = Animation.interrupt [ 
                                                    Animation.wait (Time.millisToPosix 50)
                                                   , Animation.to [ Animation.opacity 0.0 ]
                                                   , Animation.Messenger.send (CurrentNoteFadeAnimCompleted)
                                                   ]
                                                   model.currentNoteStyle
              }
              , Cmd.none
            )
        
        CurrentNoteFadeAnimCompleted -> ( { model | currentNote = Nothing }, Cmd.none )

        NotePressed noteCode -> updateNotePressed noteCode model


        CorrectNoteFadeAnimCompleted ->
          ( { model | correctNoteStyle = Animation.style [ Animation.opacity 0.0, Animation.fill Color.black ] }
          , Task.perform RestartTimer Time.now
          )

        StartGame ->
            ( { model | isPlaying = True }
            , Task.perform RestartTimer Time.now -- request current time...
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
            ( { model | correctNote = Note.createNote midiCode
              , correctNoteStyle = Animation.interrupt [ Animation.to [ Animation.opacity 1.0] ] model.correctNoteStyle
              }
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

        TestTick currentTimestamp ->
          ( { model | testCurrentTimestamp = Just currentTimestamp }
          , Cmd.none
          )

        Animate animMsg ->
            UpdateAnimations.update animMsg model

-- --------- -------- test ----------------- ------
        StartSpriteTestAnim ->
          let
              test = Debug.log "called StartSpriteTestAnim section of update" model.coinStyle
          in
            ( { model | coinStyle = Animation.interrupt [Animations.coinLoop] model.coinStyle }
            , Cmd.none
            )

        TestSpriteAnim animMsg ->
          let
              (newStyle, cmd) = Animation.Messenger.update animMsg model.coinStyle
          in
            ( { model | coinStyle = newStyle } , cmd )



        StartScrollGameLevel ->
            ( { model | gameLevelScrollState = Animation.interrupt [Animations.scrollGameLevel model.nextTargetNoteIndex] model.gameLevelScrollState }
            , Cmd.none
            )





        ScrollGameLevel animMsg ->
          let
              (newStyle, cmd) = Animation.Messenger.update animMsg model.gameLevelScrollState
          in
            ( { model | gameLevelScrollState = newStyle } , cmd )



updateNotePressed noteCode model =
  let
    newCurrentNote = Note.createNote noteCode
    nextTargetNote = getNextTargetNote model.nextTargetNoteIndex model.targetNotes
    isCorrect = getIsCorrect nextTargetNote (Just newCurrentNote)
    
    newNextTargetNoteIndex = if isCorrect then (model.nextTargetNoteIndex + 1) else model.nextTargetNoteIndex

    test = Debug.log "new next target note index: " newNextTargetNoteIndex
    
    newCurrentNoteStyle = if isCorrect
        then
            Animations.initialCurrentNoteStyle
        else
            Animation.interrupt [ Animation.set [Animation.opacity 0.0 ]
                                , Animation.to [ Animation.opacity 0.4 ]
                                ]
                                model.currentNoteStyle
  in
    ( { model
        | currentNote =
            Just newCurrentNote
        , nextTargetNoteIndex = newNextTargetNoteIndex
        , score =
            if isCorrect then model.score + 1 else model.score
        , incorrectTries =
            if isCorrect then model.incorrectTries else model.incorrectTries + 1
        , currentNoteStyle = newCurrentNoteStyle
        , gameLevelScrollState = Animation.interrupt [
          Animations.scrollGameLevel newNextTargetNoteIndex
          ] model.gameLevelScrollState
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
        , Animation.subscription (Animate << CorrectNoteStyle) [ model.correctNoteStyle ]
        , Animation.subscription (Animate << CurrentNoteStyle) [ model.currentNoteStyle ]
        -- TEST: 
        , Animation.subscription TestSpriteAnim [ model.coinStyle ]
        
        , Animation.subscription ScrollGameLevel [ model.gameLevelScrollState ]
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
    , Random.generate GenerateTargetNotes (Note.getRandomMidiList Config.notesPerLevel)
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

