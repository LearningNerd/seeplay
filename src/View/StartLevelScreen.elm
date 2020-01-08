module View.StartLevelScreen exposing (..)

import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)

import Model exposing (Model)
import Msg exposing (..)


view : Int -> Html Msg
view levelIndex =
    div [A.class "midiStatus"]
          [ p [] [ HTML.text "Ready?" ]
          , button [ A.class "startButton", onClick StartGame] [ HTML.text <| "Start level " ++ String.fromInt levelIndex ]
          ]

