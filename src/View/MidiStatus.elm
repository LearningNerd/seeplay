module View.MidiStatus exposing (view)

import Model exposing (Model, Margins)
import Msg exposing (..)
import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)


view : Model -> Html Msg
view model = 
    div [A.class "connectMidi"] [
          p [] [ HTML.text (midiStatusString model.isMIDIConnected) ]       
        ]

midiStatusString : Maybe Bool -> String
midiStatusString isConnected =
    case isConnected of
        Nothing ->
            "Connect a MIDI instrument to play!"

        Just True ->
            "Your MIDI device is connected, yay! See the note below? Play it on your instrument!"

        Just False ->
            "Hmm, looks like your MIDI device got disconnected. Try reconnecting it, or if that doesn't work, try refreshing this page or turning your MIDI device off and on again."


