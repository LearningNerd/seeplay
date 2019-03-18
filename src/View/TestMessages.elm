module View.TestMessages exposing (view)

import Model exposing (Model, Margins)
import Msg exposing (..)
import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)

import View.Note


view : Model -> Html Msg
view model = 
  let
    answerSpeedS = String.fromInt model.answerSpeed
  in
    div [] [ p [] [ HTML.text ("Note: " ++ noteInfoString model.currentNote) ]
        , p [] [ HTML.text ("CORRECT NOTE: " ++ noteInfoString (Just model.correctNote)) ]
        , p [] [ HTML.text (".....score ....: " ++ String.fromInt model.score) ]
        , p [] [ HTML.text ("START TIMESTAMP:  " ++ displayTimestamp model.startTimestamp) ]
        , p [] [ HTML.text ("ANSWER SPEED (ms):  " ++ answerSpeedS) ]
        , p [] [ HTML.text ("MS SINCE LAST ANSWER: " ++ String.fromInt ( (getMillis model.testCurrentTimestamp) - (getMillis model.startTimestamp))) ]
        , p [] [ HTML.text ("MISSES:  " ++ String.fromInt model.incorrectTries) ]
        , p [] [ HTML.text ("SESSION ID:  " ++ String.fromInt model.sessionId) ]
        ]

noteInfoString : Maybe Note -> String
noteInfoString note =
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


