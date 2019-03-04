port module Main exposing (..)


import Tuple exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)

port handleInitMIDI : (Bool -> msg) -> Sub msg
port handleNotePlayed : (Int -> msg) -> Sub msg


-- MODEL

-- for piano:
-- midi code is between 0 and 127 ... on piano, 21 to 108

pitchClass = 
  ["C", "Db", "D", "Eb", "E", "F", "Gb", "Ab", "A", "Bb", "B"]

type alias NoteName = (String, Int)

type alias Note =
  { noteName : NoteName
  , midi : Int
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
  let
      isMIDIConnectedText = 
        case model.isMIDIConnected of
          Nothing ->
            "Connect a MIDI instrument to play!"
          Just True ->
            "Your MIDI device is connected, yay! See the note below? Play it on your instrument!"
          Just False ->
            "Hmm, something went wrong with connecting to your MIDI device. Trying refreshing this page or turning your MIDI device off and on again."
  in
    div [] [
        p [] [ text isMIDIConnectedText ]
      , p [] [ text ("MIDI Code: " ++ displayNote model.currentNote) ]
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
  ]


-- MAIN

main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


createNote : Int -> Note
createNote midiCode =
  { noteName = midiToNoteName midiCode
  , midi = midiCode  -- clamp 0 127 noteCode -- ???????
  , frequency = midiToFrequency midiCode
  }

displayNote : Maybe Note -> String
displayNote note =
  case note of
    Nothing ->
      "nothing here"
    Just x ->
      first x.noteName ++ (second x.noteName |> String.fromInt)


-- NOTE CONVERSION HELPER FUNCTIONS

midiToNoteName : Int -> NoteName
midiToNoteName midiCode =
  ("C", 4)

midiToFrequency : Int -> Float
midiToFrequency midiCode =
  261.6255653006

