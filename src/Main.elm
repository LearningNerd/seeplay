port module Main exposing (..)

import Array exposing (..)
import Browser
import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Random
import Svg exposing (..)
import Svg.Attributes as S exposing (..)
import Tuple exposing (..)
import Task
import Time
import Json.Encode as E
import Animation
import Animation.Messenger

import Model exposing (Model, Score, initialModel)
import Color
import Animations
import Msg exposing (..)
import Note exposing (Note)
import UpdateAnimations

port handleInitMIDI : (Bool -> msg) -> Sub msg
port handleNotePressed : (Int -> msg) -> Sub msg
port handleNoteReleased : (Bool -> msg) -> Sub msg


port cache : E.Value -> Cmd msg


-- Fake data from fakemidi.js (manual testing in browser)
port fakeHandleInitMIDI : (Bool -> msg) -> Sub msg
port fakeHandleNotePressed : (Int -> msg) -> Sub msg
port fakeHandleNoteReleased : (Bool -> msg) -> Sub msg


-- SVG stuff
type alias Margins =
    { top : Float, right : Float, bottom : Float, left : Float }


trebleClef x y =
    let
        xS =
            String.fromFloat x

        yS =
            String.fromFloat y
    in
    text_ [ S.x xS, S.y yS, S.class "treble" ] [ HTML.text "𝄞" ]


staffLines : Float -> Float -> Margins -> Int -> Svg msg
staffLines staffWidth lineHeight margins yPos =
    let
        lineYString =
            String.fromFloat (margins.top + (toFloat yPos * lineHeight))
    in
    line
        [ S.x1 (String.fromFloat margins.left)
        , S.y1 lineYString
        , S.x2 (String.fromFloat (margins.left + staffWidth))
        , S.y2 lineYString
        , S.stroke "black"
        ]
        []


staff : Float -> Float -> Margins -> List (Svg msg)
staff staffWidth lineHeight margins =
    List.map (staffLines staffWidth lineHeight margins) (List.range 1 5)



getNoteHeight midiCode = 
  case midiCode of
    60 -> 12
    62 -> 11
    64 -> 10
    65 -> 9
    67 -> 8
    69 -> 7
    71 -> 6
    72 -> 5
    74 -> 4
    76 -> 3
    77 -> 2
    79 -> 1
    _ -> 12

drawNote : Float -> Float -> Margins -> Note -> (Animation.Messenger.State Msg) -> Svg msg
drawNote staffWidth lineHeight margins note animStyle =
    let
        yPosFloat =
            toFloat (getNoteHeight note.midi)
    
        cxString =
            String.fromFloat (staffWidth/2)

        cyString =
            String.fromFloat (margins.top + (yPosFloat * lineHeight / 2))
    in
    circle
      ( [ S.cx cxString
        , S.cy cyString
        , S.r (String.fromFloat (lineHeight / 2))
        ] ++ (Animation.render animStyle)
      )
        []



{--
allNotes : Float -> Float -> Margins -> List (Svg msg)
allNotes staffWidth lineHeight margins =
    List.map (drawNote staffWidth lineHeight margins) (List.range 60 60)
--}
-- (List.map toFloat (List.range 1 12))


svgView : Model -> Float -> Float -> Margins -> Svg Msg
svgView model width height margins =
    let
        lineHeight =
            height / 6

        widthS =
            String.fromFloat (width + margins.left + margins.right)

        heightS =
            String.fromFloat (height + margins.top + margins.bottom)
        
        drawNoteFunc = drawNote width lineHeight margins
        currentNoteDrawing = case model.currentNote of
                                 Nothing -> []
                                 Just n -> [ drawNoteFunc n model.currentNoteStyle ]
    in
    svg
        [ S.width widthS
        , S.height heightS
        , S.viewBox ("0 0 " ++ widthS ++ " " ++ heightS)
        , S.class "center"
        ]
        ((staff width lineHeight margins ++ [drawNoteFunc model.correctNote model.correctNoteStyle])
            ++ currentNoteDrawing ++ [ trebleClef 50 237 ]
        )


-- TIME HELPER...
displayTimestamp timestamp =
  case timestamp of
        Nothing -> "EMPTY"
        Just t -> String.fromInt (Time.posixToMillis t)

getMillis timestamp =
  case timestamp of
        Nothing -> 0
        Just t -> Time.posixToMillis t


-- UI PIECES

waitForMidiView : Model -> Html Msg
waitForMidiView model = 
    div [A.class "connectMidi"] [
          p [] [ HTML.text (displayMIDIStatus model.isMIDIConnected) ]       
        ]

startScreenView : Model -> Html Msg
startScreenView model =
    div [A.class "startScreen"] [
          button [ A.class "startButton", onClick StartGame] [ HTML.text "Start playing!" ]
        ]

gameView : Model -> Html Msg
gameView model =
    svgView model 500 200 { top = 50, left = 50, bottom = 50, right = 50 }


testMessagesView : Model -> Html Msg
testMessagesView model = 
  let
    answerSpeedS = String.fromInt model.answerSpeed
  in
    div [] [ p [] [ HTML.text ("Note: " ++ displayNote model.currentNote) ]
        , p [] [ HTML.text ("CORRECT NOTE: " ++ displayNote (Just model.correctNote)) ]
        , p [] [ HTML.text (".....score ....: " ++ String.fromInt model.score) ]
        , p [] [ HTML.text ("START TIMESTAMP:  " ++ displayTimestamp model.startTimestamp) ]
        , p [] [ HTML.text ("ANSWER SPEED (ms):  " ++ answerSpeedS) ]
        , p [] [ HTML.text ("MS SINCE LAST ANSWER: " ++ String.fromInt ( (getMillis model.testCurrentTimestamp) - (getMillis model.startTimestamp))) ]
        , p [] [ HTML.text ("MISSES:  " ++ String.fromInt model.incorrectTries) ]
        , p [] [ HTML.text ("SESSION ID:  " ++ String.fromInt model.sessionId) ]
        ]

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ case model.isMIDIConnected of
            Just True ->
              if model.isPlaying then gameView model else startScreenView model
            
            _ ->
              waitForMidiView model
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


displayMIDIStatus : Maybe Bool -> String
displayMIDIStatus isConnected =
    case isConnected of
        Nothing ->
            "Connect a MIDI instrument to play!"

        Just True ->
            "Your MIDI device is connected, yay! See the note below? Play it on your instrument!"

        Just False ->
            "Hmm, looks like your MIDI device got disconnected. Try reconnecting it, or if that doesn't work, try refreshing this page or turning your MIDI device off and on again."

displayNote : Maybe Note -> String
displayNote note =
    case note of
        Nothing ->
            "nothing here"

        Just x ->
            "Name: "
                ++ first x.noteName
                ++ (second x.noteName |> String.fromInt)
                ++ ", MIDI: "
                ++ String.fromInt x.midi
                ++ ", Frequency: "
                ++ String.fromFloat x.frequency


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

