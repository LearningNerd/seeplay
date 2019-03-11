port module Main exposing (..)


import Tuple exposing (..)
import Array exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)

port handleInitMIDI : (Bool -> msg) -> Sub msg
port handleNotePlayed : (Int -> msg) -> Sub msg

-- Fake data from fakemidi.js (manual testing in browser)
port fakeHandleInitMIDI : (Bool -> msg) -> Sub msg
port fakeHandleNotePlayed : (Int -> msg) -> Sub msg



-- MODEL

type alias NoteName = (String, Int)

type alias Note =
  { noteName : NoteName -- ("C", 4)
  , midi : Int          -- from 21 to 108, for piano
  , frequency : Float
  }


type alias Model =
  {
    isMIDIConnected: Maybe Bool
  , currentNote: Maybe Note
  }

initialModel : Model
initialModel =
  {
    isMIDIConnected = Nothing
  , currentNote = Nothing
  }

init : () -> ( Model, Cmd Msg )
init _ =
  ( initialModel,
    Cmd.none
  )


-- VIEW

view : Model -> Html Msg
view model =
    div [] [
        p [] [ text (displayMIDIStatus model.isMIDIConnected)]
      , p [] [ text ("Note: " ++ displayNote model.currentNote) ]
    ]


-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      InitMIDI isMIDIConnectedBool -> 
        ( { model | isMIDIConnected = Just isMIDIConnectedBool}
        , Cmd.none
        )

     
      NotePlayed noteCode ->
        ( { model |
            currentNote =
              Just (createNote noteCode)
          }
        , Cmd.none
        )


-- SUBSCRIPTIONS

type Msg = InitMIDI Bool
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
      "Name: " ++ first x.noteName ++ (second x.noteName |> String.fromInt)
      ++ ", MIDI: " ++ String.fromInt x.midi
      ++ ", Frequency: " ++ String.fromFloat x.frequency


-- NOTE CONVERSION HELPER FUNCTIONS

midiToNoteName : Int -> NoteName
midiToNoteName midiCode =
  let
    pitchClasses = Array.fromList 
      ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
    index = remainderBy 12 midiCode
    pitchClass =  case (Array.get index pitchClasses) of
                    Nothing -> "C" -- if index out of bounds (impastable!!)
                    Just x -> x
    octave = (midiCode // 12) - 1
  in
    (pitchClass, octave)


midiToFrequency : Int -> Float
midiToFrequency midiCode =
  let
    -- 2 ^ (1/12) is the frequency ratio of each note...????
    semitoneRatio =  1.0594630943592953
    -- MIDI code 0 starts at about 8 Hz frequency
    lowestFreq = 8.1757989156
  in
    lowestFreq * (semitoneRatio ^ toFloat midiCode)
  -- Sources: https://en.wikipedia.org/wiki/Pitch_(music)#Labeling_pitches
  -- http://subsynth.sourceforge.net/midinote2freq.html
  -- and https://newt.phys.unsw.edu.au/jw/notes.html


