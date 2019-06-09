module View.Coin exposing (view, numSpriteFrames)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import ConstantsHelpers


numSpriteFrames = 4

baseSpriteWidth = 16
baseSpriteHeight = 16

widthToHeightRatio = baseSpriteWidth / baseSpriteHeight


spriteWidth = (ConstantsHelpers.staffLineHeight * 0.8) * widthToHeightRatio
spriteHeight = ConstantsHelpers.staffLineHeight * 0.8


view xS yS spriteIndex =
  let
    viewBoxStartXString = String.fromInt (spriteIndex * baseSpriteWidth)
  in
    svg
    [ viewBox (viewBoxStartXString ++ " 0 " ++ String.fromFloat baseSpriteWidth ++ " " ++ String.fromFloat baseSpriteHeight)
    , width (String.fromFloat spriteWidth)
    , height (String.fromFloat spriteHeight)
    , x xS
    , y yS
    , class "sprite"
    ]
    [ image [xlinkHref "img/coin.png"] [] ]

