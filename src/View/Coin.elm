module View.Coin exposing (view)

import Animation
import Animation.Messenger
import Svg exposing (..)
import Svg.Attributes exposing (..)

import Model exposing (Model, Margins)
import Msg exposing (..)


view animState xS yS heightS =
  let
    spriteWidth = 16
    spriteHeight = 16
  in
  svg (Animation.render animState ++ 
    [ width heightS -- (String.fromInt 16) ,
    , height heightS
    , x xS
    , y yS
    , class "sprite"
    ])
    [ image [xlinkHref "img/coin.png"] [] ]

