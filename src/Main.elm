port module Main exposing (..)


import Browser
import Html exposing (..)
import Html.Attributes exposing (..)

port handleInitMIDI : (Bool -> msg) -> Sub msg
port handleNotePlayed : (Int -> msg) -> Sub msg


-- MODEL

type alias Model =
  {
    isMIDIConnected: Maybe Bool
  , currentMIDICode: Int
  }

initialModel : Model
initialModel =
  {
    isMIDIConnected = Nothing
  , currentMIDICode = 0
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
      , p [] [ text ("MIDI Code: " ++ String.fromInt model.currentMIDICode) ]
    ]


-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      InitMIDI isMIDIConnectedBool ->
        ( { model |
            isMIDIConnected = 
              if isMIDIConnectedBool == True then
                 Just True
              else
                Just False
          }
        , Cmd.none
        )
      
      NotePlayed noteCode ->
        ( { model | currentMIDICode = noteCode }
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

