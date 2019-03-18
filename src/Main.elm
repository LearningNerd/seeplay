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
import Animation exposing (px)
import Animation.Messenger

port handleInitMIDI : (Bool -> msg) -> Sub msg
port handleNotePressed : (Int -> msg) -> Sub msg
port handleNoteReleased : (Bool -> msg) -> Sub msg


port cache : E.Value -> Cmd msg


-- Fake data from fakemidi.js (manual testing in browser)


port fakeHandleInitMIDI : (Bool -> msg) -> Sub msg
port fakeHandleNotePressed : (Int -> msg) -> Sub msg
port fakeHandleNoteReleased : (Bool -> msg) -> Sub msg


-- MOVE TO a Color.Palette module ????
type alias Color =
    { red : Int, blue : Int, green : Int, alpha : Float }
rgba r g b a =
    { red = r, blue = b, green = g, alpha = a }
rgb r g b =
    { red = r, blue = b, green = g, alpha = 1 }


-- MODEL


type alias NoteName =
    ( String, Int )


type alias Note =
    { noteName : NoteName -- ("C", 4)
    , midi : Int -- from 21 to 108, for piano
    , frequency : Float
    }

type alias Score =
  { correctNote : Note -- midi code of the Note (not the Note itself!)
  , answerSpeed : Int
  , incorrectTries : Int
  }

type alias Model =
    { isMIDIConnected : Maybe Bool
    , isPlaying : Bool
    , correctNote : Note
    , currentNote : Maybe Note
    , score : Int
    , startTimestamp : Maybe Time.Posix
    , answerSpeed : Int -- result of subtracting two times via posixToMillis
    , incorrectTries : Int
    , scoreList : List Score -- store a list of score records for each practice session ... goes into local storage
    , testCurrentTimestamp : Maybe Time.Posix
    , sessionId : Int
    , style : Animation.Messenger.State Msg
    , currentNoteStyle : Animation.Messenger.State Msg
    , correctNoteStyle : Animation.Messenger.State Msg
    }




initialModel : Model
initialModel =
    { isMIDIConnected = Nothing
    , isPlaying = False
    , correctNote = createNote 60
    , currentNote = Nothing
    , score = 0
    , startTimestamp = Nothing
    , answerSpeed = 0
    , incorrectTries = 0
    , scoreList = []
    , testCurrentTimestamp = Nothing
    , sessionId = 0
    , style = Animation.style [ Animation.opacity 1.0 ]
    , currentNoteStyle = initialCurrentNoteStyle
    , correctNoteStyle = initialCorrectNoteStyle
    }

-- Get session ID from JS flag (starts at 0, or incremented from localstorage)
init : Int -> ( Model, Cmd Msg )
init initialSessionId =
  ( { initialModel | sessionId = initialSessionId }
    , Random.generate UpdateCorrectNote getRandomMidi -- generate first note to guess on app load!
  )


-- SVG stuff

-- initialCurrentNoteStyle : Animation.Messenger.State Msg
initialCurrentNoteStyle =
  Animation.style [ Animation.opacity 0.0, Animation.fill (rgb 255 20 20) ]

-- initialCorrectNoteStyle : Animation.Messenger.State Msg
initialCorrectNoteStyle =
  Animation.style [ Animation.opacity 1.0, Animation.fill (rgb 0 0 0) ]

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
        [ -- if model.hasTestThingy then animationTestView model else HTML.text ""
        -- , (
          case model.isMIDIConnected of
            Just True ->
              if model.isPlaying then gameView model else startScreenView model
            _ ->
              waitForMidiView model
          -- )
        ]

animationTestView model =
  p (Animation.render model.style ++ [ onClick FadeInFadeOut, A.style "background-color" "blue"]) [HTML.text "click meeee"]


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
{--                  , correctNoteStyle =
                    Animation.interrupt
                        [ Animation.to [ Animation.fill (rgb 0 255 0)]
                        ]
                        model.currentNoteStyle
   --}     
              }
              , Cmd.none
            )
        
        CurrentNoteFadeAnimCompleted -> ( { model | currentNote = Nothing }, Cmd.none )

        NotePressed noteCode ->
            let
                newCurrentNote = createNote noteCode
                isCorrect = getIsCorrect model.correctNote (Just newCurrentNote)
                newCorrectNoteStyle = if isCorrect
                    then
                                 Animation.interrupt [ Animation.to [ Animation.fill (rgb 0 255 0) ]
                                 , Animation.wait (Time.millisToPosix 60)
                                 , Animation.to [ Animation.opacity 0.0 ]
                                    -- , Animation.fill (rgb 0 0 0)
                                    -- this doesn't work because the Anim can only send a Cmd msg, NOT execute a task
                                    -- , Animation.Messenger.send (Task.perform RestartTimer Time.now)
                                 , Animation.Messenger.send (CorrectNoteFadeAnimCompleted) -- <<< so this is the workaround!
                                 ] model.correctNoteStyle
                    else 
                                -- model.correctNoteStyle
                                initialCorrectNoteStyle
                newCurrentNoteStyle = if isCorrect
                    then
                        initialCurrentNoteStyle
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
          ( { model | correctNoteStyle = Animation.style [ Animation.opacity 0.0, Animation.fill (rgb 0 0 0) ] }
          , Task.perform RestartTimer Time.now
          )

        StartGame ->
            ( { model | isPlaying = True }
            , Task.perform RestartTimer Time.now -- request current time...
            )

        -- called when page loads to initialize correctNote, and again on each correct note played!
        UpdateCorrectNote midiCode ->
            ( { model | correctNote = createNote midiCode
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
                                , Random.generate UpdateCorrectNote getRandomMidi
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

        FadeInFadeOut -> updateFadeInFadeOut model
        Animate animMsg-> updateAnimate animMsg model

        -- .... gotta refactor this lolz! need to map over every thingy that needs animating
        AnimateCurrentNote animMsg -> updateAnimateCurrentNote animMsg model
        AnimateCorrectNote animMsg -> updateAnimateCorrectNote animMsg model

-- ANIMATION EXPERIMENT via:
-- https://github.com/mdgriffith/elm-style-animation/blob/master/examples/SimpleFadeIn.elm

updateFadeInFadeOut model = 
          ( { model
                | style =
                    Animation.interrupt
                        [ Animation.to
                            [ Animation.opacity 0
                            ]
                        , Animation.wait (Time.millisToPosix 2000)
                        ]
                        model.style
              }
            , Cmd.none
            )

updateAnimate animMsg model =
        let
            (newStyle, cmd) =
              Animation.Messenger.update animMsg model.style
        in
            ( { model
                | style = newStyle
              }
            , cmd -- send any messages triggered by animations
            )
updateAnimateCurrentNote animMsg model =
        let
            (newStyle, cmd) =
              Animation.Messenger.update animMsg model.currentNoteStyle
        in
            ( { model
                | currentNoteStyle = newStyle
              }
            , cmd -- send any messages triggered by animations
            )
updateAnimateCorrectNote animMsg model =
        let
            (newStyle, cmd) =
              Animation.Messenger.update animMsg model.correctNoteStyle
        in
            ( { model
                | correctNoteStyle = newStyle
              }
            , cmd -- send any messages triggered by animations
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

-- SUBSCRIPTIONS


type Msg
    = InitMIDI Bool
    | NotePressed Int
    | NoteReleased Bool
    | UpdateCorrectNote Int
    | StartGame
    | RestartTimer Time.Posix
    | TestTick Time.Posix
    | FadeInFadeOut
    | Animate Animation.Msg
    | AnimateCorrectNote Animation.Msg
    | AnimateCurrentNote Animation.Msg
    | CorrectNoteFadeAnimCompleted
    | CurrentNoteFadeAnimCompleted

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
        , Animation.subscription Animate [ model.style ]
        , Animation.subscription AnimateCorrectNote [ model.correctNoteStyle ]
        , Animation.subscription AnimateCurrentNote [ model.currentNoteStyle ]
        ]



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


displayMIDIStatus : Maybe Bool -> String
displayMIDIStatus isConnected =
    case isConnected of
        Nothing ->
            "Connect a MIDI instrument to play!"

        Just True ->
            "Your MIDI device is connected, yay! See the note below? Play it on your instrument!"

        Just False ->
            "Hmm, looks like your MIDI device got disconnected. Try reconnecting it, or if that doesn't work, try refreshing this page or turning your MIDI device off and on again."


createNote : Int -> Note
createNote midiCode =
    { noteName = midiToNoteName midiCode
    , midi = clamp 21 108 midiCode -- assuming piano MIDI!
    , frequency = midiToFrequency midiCode
    }


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


getRandomMidi : Random.Generator Int
getRandomMidi =
  Random.uniform 60 [
    62,
    64,
    65,
    67,
    69,
    71,
    72,
    74,
    76,
    77,
    79]

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

-- NOTE CONVERSION HELPER FUNCTIONS


midiToNoteName : Int -> NoteName
midiToNoteName midiCode =
    let
        pitchClasses =
            Array.fromList
                [ "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B" ]

        index =
            remainderBy 12 midiCode

        pitchClass =
            case Array.get index pitchClasses of
                Nothing ->
                    "C"

                -- if index out of bounds (impastable!!)
                Just x ->
                    x

        octave =
            (midiCode // 12) - 1
    in
    ( pitchClass, octave )


midiToFrequency : Int -> Float
midiToFrequency midiCode =
    let
        -- 2 ^ (1/12) is the frequency ratio of each note...????
        semitoneRatio =
            1.0594630943592953

        -- MIDI code 0 starts at about 8 Hz frequency
        lowestFreq =
            8.1757989156
    in
    lowestFreq * (semitoneRatio ^ toFloat midiCode)



-- Sources: https://en.wikipedia.org/wiki/Pitch_(music)#Labeling_pitches
-- http://subsynth.sourceforge.net/midinote2freq.html
-- and https://newt.phys.unsw.edu.au/jw/notes.html

logMidiCode maybeNote =
  case maybeNote of
    Nothing -> "Nothing"
    Just n -> 
      let
          noteNameString = first n.noteName ++ String.fromInt (second n.noteName)
      in
        String.fromInt n.midi ++ "(" ++ noteNameString ++ ")"


