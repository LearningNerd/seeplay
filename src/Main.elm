port module Main exposing (Model, Msg(..), Note, NoteName, createNote, displayMIDIStatus, displayNote, fakeHandleInitMIDI, fakeHandleNotePlayed, handleInitMIDI, handleNotePlayed, init, initialModel, main, midiToFrequency, midiToNoteName, pickRandomNote, subscriptions, update, updateScore, view)

-- import Html.Attributes as A exposing (..)

import Array exposing (..)
import Browser
import Html as HTML exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)
import Tuple exposing (..)


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
    }


initialModel : Model
initialModel =
    { isMIDIConnected = Nothing
    , correctNote = pickRandomNote ()
    , currentNote = Nothing
    , score = 0
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel
    , Cmd.none
    )



-- SVG


svgView =
    svg
        [ S.width "120"
        , S.height "120"
        , S.viewBox "0 0 120 120"
        ]
        [ circle [ S.cx "50", S.cy "50", S.r "50" ] []
        , staff 
        ]

staff = line [ S.x1 "0", S.y1 "0", S.x2 "100", S.y2 "100", S.stroke "black" ] []


-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ p [] [ HTML.text (displayMIDIStatus model.isMIDIConnected) ]
        , p [] [ HTML.text ("Note: " ++ displayNote model.currentNote) ]
        , p [] [ HTML.text ("CORRECT NOTE: " ++ displayNote (Just model.correctNote)) ]
        , p [] [ HTML.text (".....score ....: " ++ String.fromInt model.score) ]
        , svgView
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
                newNote =
                    createNote noteCode
            in
            ( { model
                | currentNote =
                    Just newNote
                , score =
                    updateScore model.score model.correctNote newNote
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


type Msg
    = InitMIDI Bool
    | NotePlayed Int


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ handleInitMIDI InitMIDI
        , handleNotePlayed NotePlayed

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



-- TODO: learn how to generate random numbers...


pickRandomNote : a -> Note
pickRandomNote _ =
    createNote 60


updateScore : Int -> Note -> Note -> Int
updateScore score correctNote currentNote =
    if currentNote.midi == correctNote.midi then
        score + 1

    else
        score



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
