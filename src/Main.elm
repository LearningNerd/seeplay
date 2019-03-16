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


port handleInitMIDI : (Bool -> msg) -> Sub msg


port handleNotePlayed : (Int -> msg) -> Sub msg



-- Fake data from fakemidi.js (manual testing in browser)


port fakeHandleInitMIDI : (Bool -> msg) -> Sub msg


port fakeHandleNotePlayed : (Int -> msg) -> Sub msg



-- MODEL


type alias NoteName =
    ( String, Int )


type alias Note =
    { noteName : NoteName -- ("C", 4)
    , midi : Int -- from 21 to 108, for piano
    , frequency : Float
    }


type alias Model =
    { isMIDIConnected : Maybe Bool
    , correctNote : Note
    , currentNote : Maybe Note
    , score : Int
    , startTimestamp : Maybe Time.Posix
    , answerSpeed : Maybe Int -- result of subtracting two times via posixToMillis
    , answerAttempts : Int
    , testCurrentTimestamp : Maybe Time.Posix
    }

 

initialModel : Model
initialModel =
    { isMIDIConnected = Nothing
    , correctNote = createNote 60
    , currentNote = Nothing
    , score = 0
    , startTimestamp = Nothing
    , answerSpeed = Nothing
    , answerAttempts = 0
    , testCurrentTimestamp = Nothing
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel
    , Cmd.none
    )



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

drawNote : Float -> Float -> Margins -> Note -> Svg msg
drawNote staffWidth lineHeight margins correctNote =
    let
        yPosFloat =
            -- toFloat (72 - correctNote.midi)
            toFloat (getNoteHeight correctNote.midi)
    
        cxString =
            String.fromFloat (staffWidth/2)

        cyString =
            String.fromFloat (margins.top + (yPosFloat * lineHeight / 2))
    in
    circle
        [ S.cx cxString
        , S.cy cyString
        , S.r (String.fromFloat (lineHeight / 2))
        ]
        []



{--
allNotes : Float -> Float -> Margins -> List (Svg msg)
allNotes staffWidth lineHeight margins =
    List.map (drawNote staffWidth lineHeight margins) (List.range 60 60)
--}
-- (List.map toFloat (List.range 1 12))


svgView : Note -> Float -> Float -> Margins -> Svg Msg
svgView correctNote width height margins =
    let
        lineHeight =
            height / 6

        widthS =
            String.fromFloat (width + margins.left + margins.right)

        heightS =
            String.fromFloat (height + margins.top + margins.bottom)
    in
    svg
        [ S.width widthS
        , S.height heightS
        , S.viewBox ("0 0 " ++ widthS ++ " " ++ heightS)
        , S.class "center"
        ]
        ((staff width lineHeight margins ++ [drawNote width lineHeight margins correctNote])
            ++ [ trebleClef 50 237 ]
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


-- VIEW


view : Model -> Html Msg
view model =
  let
      answerSpeedS =
        case model.answerSpeed of
          Nothing -> "EMPTY"
          Just i -> String.fromInt i
  in
    div []
        [ p [] [ HTML.text (displayMIDIStatus model.isMIDIConnected) ]
        , button [ A.class "startbutton", onClick GetRandomMidi] [ HTML.text "Start playing!" ]
        , p [] [ HTML.text ("Note: " ++ displayNote model.currentNote) ]
        , p [] [ HTML.text ("CORRECT NOTE: " ++ displayNote (Just model.correctNote)) ]
        , p [] [ HTML.text (".....score ....: " ++ String.fromInt model.score) ]
        , svgView model.correctNote 500 200 { top = 50, left = 50, bottom = 50, right = 50 }

        , p [] [ HTML.text ("START TIMESTAMP:  " ++ displayTimestamp model.startTimestamp) ]
        , p [] [ HTML.text ("ANSWER SPEED (ms):  " ++ answerSpeedS) ]
        , p [] [ HTML.text ("MS SINCE LAST ANSWER: " ++ String.fromInt ( (getMillis model.testCurrentTimestamp) - (getMillis model.startTimestamp))) ]
        
        , p [] [ HTML.text ("MISSES:  " ++ String.fromInt model.answerAttempts) ]
        ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =

    case msg of
        InitMIDI isMIDIConnectedBool ->
            ( { model | isMIDIConnected = Just isMIDIConnectedBool }
            , Cmd.none
            )

        NotePlayed noteCode ->
            let
                newNote = createNote noteCode
                scoreResult = updateScore model.score model.correctNote newNote
            in
            ( { model
                | currentNote =
                    Just newNote
                , score =
                    first scoreResult
                , answerAttempts =
                  case second scoreResult of
                    True -> 0 -- reset answerAttempts when getting correct answer
                    False -> model.answerAttempts + 1 -- increase answerAttempts for each wrong guess
              }
            , if (second scoreResult) == True then
                 Random.generate UpdateCorrectNote getRandomMidi
              else
                Cmd.none
            )

        GetRandomMidi ->
            ( model
            , Random.generate UpdateCorrectNote getRandomMidi
            )

        UpdateCorrectNote midiCode ->
            ( { model | correctNote = createNote midiCode }
            , Task.perform RestartTimer Time.now -- request current time...
            )
        
        RestartTimer currentTimestamp ->
          {-- calculate time since start ...
          --}
            ( { model
                 | answerSpeed = -- if this is the first question,
                   case model.startTimestamp of
                     Nothing -> Nothing -- don't update answerSpeed
                     Just t -> 
                       Just ((Time.posixToMillis currentTimestamp) - (Time.posixToMillis t)) -- else, update speed!
                  
                  , startTimestamp = Just currentTimestamp -- always update start time
                  , testCurrentTimestamp = Just currentTimestamp
              }
            , Cmd.none
            )

        TestTick currentTimestamp ->
          ( { model | testCurrentTimestamp = Just currentTimestamp }
          , Cmd.none
          )



-- SUBSCRIPTIONS


type Msg
    = InitMIDI Bool
    | NotePlayed Int
    | UpdateCorrectNote Int
    | GetRandomMidi
    | RestartTimer Time.Posix
    | TestTick Time.Posix

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ handleInitMIDI InitMIDI
        , handleNotePlayed NotePlayed
        , Time.every 10 TestTick -- every 10 ms
        -- ************************************************
        -- Fake data from fakemidi.js for manual testing:
        -- ************************************************
        , fakeHandleInitMIDI InitMIDI
        , fakeHandleNotePlayed NotePlayed
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
            "Hmm, something went wrong with connecting to your MIDI device. Try refreshing this page or turning your MIDI device off and on again."


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
