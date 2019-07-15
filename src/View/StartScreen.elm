module View.StartScreen exposing (..)

import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)

import Model exposing (Model)
import Msg exposing (..)


view =
    div [A.class "startScreen"] [
          button [ A.class "startButton", onClick StartGame] [ HTML.text "Start playing!" ]
        ]

