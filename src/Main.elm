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
import View.TestSprite

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
    div []
        [ View.Header.view model
        , main_ [A.class "container"]
          [ Html.p [onClick StartSpriteTestAnim ] [ Html.text "hey click me!"]
          , Html.p [onClick StartTestSpriteBounce ] [ Html.text "  ...and then click me too!"]
                 
          , case model.isMIDIConnected of
            -- If Nothing or False (waiting to init or no MIDI available), then show the MidiStatus screen (waiting for input)
            Nothing ->
              -- View.MidiStatus.view model
              View.TestSprite.view model

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

        NotePressed noteCode ->
            let
                newCurrentNote = Note.createNote noteCode
                isCorrect = getIsCorrect model.correctNote (Just newCurrentNote)
                newCorrectNoteStyle = if isCorrect
                    then
                                 Animation.interrupt [ Animation.to [ Animation.fill Color.green]
                                 , Animation.wait (Time.millisToPosix 60)
                                 , Animation.to [ Animation.opacity 0.0 ]
                                    -- , Animation.fill (rgb 0 0 0)
                                    -- this doesn't work because the Anim can only send a Cmd msg, NOT execute a task
                                    -- , Animation.Messenger.send (Task.perform RestartTimer Time.now)
                                 , Animation.Messenger.send (CorrectNoteFadeAnimCompleted) -- <<< so this is the workaround!
                                 ] model.correctNoteStyle
                    else 
                                -- model.correctNoteStyle
                                Animations.initialCorrectNoteStyle
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
                , score =
                    if isCorrect then model.score + 1 else model.score
                , incorrectTries =
                    if isCorrect then model.incorrectTries else model.incorrectTries + 1
                , correctNoteStyle = newCorrectNoteStyle
                , currentNoteStyle = newCurrentNoteStyle
              }
            -- , nextCommand
            , Cmd.none
            )
        
        CorrectNoteFadeAnimCompleted ->
          ( { model | correctNoteStyle = Animation.style [ Animation.opacity 0.0, Animation.fill Color.black ] }
          , Task.perform RestartTimer Time.now
          )

        StartGame ->
            ( { model | isPlaying = True }
            , Task.perform RestartTimer Time.now -- request current time...
            )

        -- called when page loads to initialize correctNote, and again on each correct note played!
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
                                , Random.generate UpdateCorrectNote Note.getRandomMidi
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
              test = Debug.log "called StartSpriteTestAnim section of update" model.spriteStyle
          in
            ( { model | spriteStyle = Animation.interrupt [Animations.circleLoop] model.spriteStyle }
            , Cmd.none
            )

        StartTestSpriteBounce ->
          let
              test = Debug.log "called StartTestSpriteBounce section of update" model.circleBounceStyle
          in
            ( { model | circleBounceStyle = Animation.interrupt Animations.circleBounce model.circleBounceStyle }
            , Cmd.none
            )


        TestSpriteAnim animMsg ->
          let
              (newStyle, cmd) = Animation.Messenger.update animMsg model.spriteStyle
          in
            ( { model | spriteStyle = newStyle } , cmd )

        TestSpriteBounce animMsg ->
          let
              (newStyle, cmd) = Animation.Messenger.update animMsg model.circleBounceStyle
          in
            ( { model | circleBounceStyle = newStyle } , cmd )



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
        , Animation.subscription TestSpriteAnim [ model.spriteStyle ]
        , Animation.subscription TestSpriteBounce [ model.circleBounceStyle ]
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
  ( { initialModel | sessionId = initialSessionId }
    , Random.generate UpdateCorrectNote Note.getRandomMidi -- generate first note to guess on app load!
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

