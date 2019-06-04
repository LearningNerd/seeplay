module View.Coin exposing (view)

import Svg exposing (..)
import Svg.Attributes exposing (..)

import Model exposing (Model, Margins)
import Msg exposing (..)


view xS yS heightS =
  let
    spriteWidth = 16
    spriteHeight = 16
  in
  svg
    [ width heightS -- (String.fromInt 16) ,
    , height heightS
    , x xS
    , y yS
    , class "sprite"
    ]
    [ image [xlinkHref "img/coin.png"] [] ]

