module View.Coin exposing (view)

import Animation
import Animation.Messenger
import Model exposing (Model, Margins)
import Msg exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)

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
    ])
    [ -- starting SVG data below: 
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 0)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 0)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 0)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 0)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 0)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 0)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 0)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 0)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 0)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 0)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 1)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 1)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 1)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 1)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 1)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 1)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 1)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 1)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 1)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 1)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 1)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 1)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 1)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 1)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 1)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 1)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 1)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 1)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 1)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 1)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 1)
            , y (String.fromInt 2)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 2)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 2)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 2)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 2)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 2)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 2)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 2)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 2)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 10)
            , y (String.fromInt 2)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 19)
            , y (String.fromInt 2)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 2)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 2)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 2)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 2)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 24)
            , y (String.fromInt 2)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 2)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 2)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 2)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 2)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 51)
            , y (String.fromInt 2)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 2)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 2)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 2)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 2)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 56)
            , y (String.fromInt 2)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 1)
            , y (String.fromInt 3)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 3)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 3)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 3)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 3)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 3)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 3)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 3)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 3)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 10)
            , y (String.fromInt 3)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 19)
            , y (String.fromInt 3)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 3)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 3)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 3)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 3)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 24)
            , y (String.fromInt 3)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 3)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 3)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 3)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 3)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 51)
            , y (String.fromInt 3)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 3)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 3)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 3)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 3)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 56)
            , y (String.fromInt 3)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 0)
            , y (String.fromInt 4)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 1)
            , y (String.fromInt 4)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 4)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 4)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 4)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 4)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 4)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 4)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 4)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 4)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 10)
            , y (String.fromInt 4)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 11)
            , y (String.fromInt 4)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 18)
            , y (String.fromInt 4)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 19)
            , y (String.fromInt 4)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 4)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 4)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 4)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 4)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 24)
            , y (String.fromInt 4)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 25)
            , y (String.fromInt 4)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 35)
            , y (String.fromInt 4)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 4)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 4)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 4)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 4)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 40)
            , y (String.fromInt 4)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 50)
            , y (String.fromInt 4)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 51)
            , y (String.fromInt 4)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 4)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 4)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 4)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 4)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 56)
            , y (String.fromInt 4)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 57)
            , y (String.fromInt 4)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 0)
            , y (String.fromInt 5)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 1)
            , y (String.fromInt 5)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 5)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 5)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 5)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 5)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 5)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 5)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 5)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 5)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 10)
            , y (String.fromInt 5)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 11)
            , y (String.fromInt 5)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 18)
            , y (String.fromInt 5)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 19)
            , y (String.fromInt 5)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 5)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 5)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 5)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 5)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 24)
            , y (String.fromInt 5)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 25)
            , y (String.fromInt 5)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 35)
            , y (String.fromInt 5)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 5)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 5)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 5)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 5)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 40)
            , y (String.fromInt 5)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 50)
            , y (String.fromInt 5)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 51)
            , y (String.fromInt 5)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 5)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 5)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 5)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 5)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 56)
            , y (String.fromInt 5)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 57)
            , y (String.fromInt 5)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 0)
            , y (String.fromInt 6)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 1)
            , y (String.fromInt 6)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 6)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 6)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 6)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 6)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 6)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 6)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 6)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 6)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 10)
            , y (String.fromInt 6)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 11)
            , y (String.fromInt 6)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 18)
            , y (String.fromInt 6)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 19)
            , y (String.fromInt 6)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 6)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 6)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 6)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 6)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 24)
            , y (String.fromInt 6)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 25)
            , y (String.fromInt 6)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 35)
            , y (String.fromInt 6)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 6)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 6)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 6)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 6)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 40)
            , y (String.fromInt 6)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 50)
            , y (String.fromInt 6)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 51)
            , y (String.fromInt 6)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 6)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 6)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 6)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 6)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 56)
            , y (String.fromInt 6)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 57)
            , y (String.fromInt 6)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 0)
            , y (String.fromInt 7)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 1)
            , y (String.fromInt 7)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 7)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 7)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 7)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 7)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 7)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 7)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 7)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 7)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 10)
            , y (String.fromInt 7)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 11)
            , y (String.fromInt 7)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 18)
            , y (String.fromInt 7)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 19)
            , y (String.fromInt 7)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 7)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 7)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 7)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 7)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 24)
            , y (String.fromInt 7)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 25)
            , y (String.fromInt 7)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 35)
            , y (String.fromInt 7)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 7)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 7)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 7)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 7)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 40)
            , y (String.fromInt 7)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 50)
            , y (String.fromInt 7)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 51)
            , y (String.fromInt 7)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 7)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 7)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 7)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 7)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 56)
            , y (String.fromInt 7)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 57)
            , y (String.fromInt 7)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 0)
            , y (String.fromInt 8)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 1)
            , y (String.fromInt 8)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 8)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 8)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 8)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 8)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 8)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 8)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 8)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 8)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 10)
            , y (String.fromInt 8)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 11)
            , y (String.fromInt 8)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 18)
            , y (String.fromInt 8)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 19)
            , y (String.fromInt 8)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 8)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 8)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 8)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 8)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 24)
            , y (String.fromInt 8)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 25)
            , y (String.fromInt 8)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 35)
            , y (String.fromInt 8)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 8)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 8)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 8)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 8)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 40)
            , y (String.fromInt 8)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 50)
            , y (String.fromInt 8)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 51)
            , y (String.fromInt 8)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 8)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 8)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 8)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 8)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 56)
            , y (String.fromInt 8)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 57)
            , y (String.fromInt 8)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 0)
            , y (String.fromInt 9)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 1)
            , y (String.fromInt 9)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 9)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 9)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 9)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 9)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 9)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 9)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 9)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 9)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 10)
            , y (String.fromInt 9)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 11)
            , y (String.fromInt 9)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 18)
            , y (String.fromInt 9)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 19)
            , y (String.fromInt 9)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 9)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 9)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 9)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 9)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 24)
            , y (String.fromInt 9)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 25)
            , y (String.fromInt 9)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 35)
            , y (String.fromInt 9)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 9)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 9)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 9)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 9)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 40)
            , y (String.fromInt 9)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 50)
            , y (String.fromInt 9)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 51)
            , y (String.fromInt 9)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 9)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 9)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 9)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 9)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 56)
            , y (String.fromInt 9)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 57)
            , y (String.fromInt 9)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 0)
            , y (String.fromInt 10)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 1)
            , y (String.fromInt 10)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 10)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 10)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 10)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 10)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 10)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 10)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 10)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 10)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 10)
            , y (String.fromInt 10)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 11)
            , y (String.fromInt 10)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 18)
            , y (String.fromInt 10)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 19)
            , y (String.fromInt 10)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 10)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 10)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 10)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 10)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 24)
            , y (String.fromInt 10)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 25)
            , y (String.fromInt 10)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 35)
            , y (String.fromInt 10)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 10)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 10)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 10)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 10)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 40)
            , y (String.fromInt 10)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 50)
            , y (String.fromInt 10)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 51)
            , y (String.fromInt 10)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 10)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 10)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 10)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 10)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 56)
            , y (String.fromInt 10)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 57)
            , y (String.fromInt 10)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 0)
            , y (String.fromInt 11)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 1)
            , y (String.fromInt 11)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 11)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 11)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 11)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 11)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 11)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 11)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 11)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 11)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 10)
            , y (String.fromInt 11)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 11)
            , y (String.fromInt 11)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 18)
            , y (String.fromInt 11)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 19)
            , y (String.fromInt 11)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 11)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 11)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 11)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 11)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 24)
            , y (String.fromInt 11)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 25)
            , y (String.fromInt 11)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 35)
            , y (String.fromInt 11)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 11)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 11)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 11)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 11)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 40)
            , y (String.fromInt 11)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 50)
            , y (String.fromInt 11)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 51)
            , y (String.fromInt 11)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 11)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 11)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 11)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 11)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 56)
            , y (String.fromInt 11)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 57)
            , y (String.fromInt 11)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 1)
            , y (String.fromInt 12)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 12)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 12)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 12)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 12)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 12)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 12)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 12)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 12)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 10)
            , y (String.fromInt 12)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 19)
            , y (String.fromInt 12)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 12)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 12)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 12)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 12)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 24)
            , y (String.fromInt 12)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 12)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 12)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 12)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 12)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 51)
            , y (String.fromInt 12)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 12)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 12)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 12)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 12)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 56)
            , y (String.fromInt 12)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 1)
            , y (String.fromInt 13)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 13)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 13)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 13)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 13)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 13)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 13)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 13)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 13)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 10)
            , y (String.fromInt 13)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 19)
            , y (String.fromInt 13)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 13)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 13)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 13)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 13)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 24)
            , y (String.fromInt 13)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 13)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 13)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 13)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 13)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 51)
            , y (String.fromInt 13)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 13)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 13)
            , fill "rgba(232, 240, 248, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 13)
            , fill "rgba(248, 248, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 13)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 56)
            , y (String.fromInt 13)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 2)
            , y (String.fromInt 14)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 3)
            , y (String.fromInt 14)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 14)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 14)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 14)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 14)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 8)
            , y (String.fromInt 14)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 9)
            , y (String.fromInt 14)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 20)
            , y (String.fromInt 14)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 14)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 14)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 23)
            , y (String.fromInt 14)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 36)
            , y (String.fromInt 14)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 14)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 14)
            , fill "rgba(216, 160, 56, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 39)
            , y (String.fromInt 14)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 52)
            , y (String.fromInt 14)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 14)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 14)
            , fill "rgba(248, 216, 32, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 55)
            , y (String.fromInt 14)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 4)
            , y (String.fromInt 15)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 5)
            , y (String.fromInt 15)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 6)
            , y (String.fromInt 15)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 7)
            , y (String.fromInt 15)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 21)
            , y (String.fromInt 15)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 22)
            , y (String.fromInt 15)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 37)
            , y (String.fromInt 15)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 38)
            , y (String.fromInt 15)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 53)
            , y (String.fromInt 15)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ,
      rect [ width "1"
            , height "1"
            , x (String.fromInt 54)
            , y (String.fromInt 15)
            , fill "rgba(0, 0, 0, 1.00)"
            ] []
      ]
