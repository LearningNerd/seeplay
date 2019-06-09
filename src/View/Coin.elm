module View.Coin exposing (view)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import ConstantsHelpers


baseSpriteWidth = 16
baseSpriteHeight = 16

widthToHeightRatio = baseSpriteWidth / baseSpriteHeight


spriteWidth = (ConstantsHelpers.staffLineHeight * 0.8) * widthToHeightRatio
spriteHeight = ConstantsHelpers.staffLineHeight * 0.8


view xS yS =
  svg
    [ viewBox (String.fromFloat baseSpriteWidth ++ " 0 " ++ String.fromFloat baseSpriteWidth ++ " " ++ String.fromFloat baseSpriteHeight)
    , width (String.fromFloat spriteWidth)
    , height (String.fromFloat spriteHeight)
    , x xS
    , y yS
    , class "sprite"
    ]
    [ image [xlinkHref "img/coin.png"] [] ]

