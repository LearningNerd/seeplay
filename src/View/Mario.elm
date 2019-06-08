module View.Mario exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Constants


-- what was this for again...?
sizeOffset = 15

widthToHeightRatio = 17 / 24 -- 17 px wide, 24 px high

baseSpriteWidth = 17
baseSpriteHeight = 24

spriteWidth = (sizeOffset + Constants.staffLineHeight) * widthToHeightRatio
spriteHeight = sizeOffset + Constants.staffLineHeight

view xS yS =
    svg 
    [ -- viewBox "0 0 " ++ String.fromFloat spriteWidth ++ " " ++ String.fromFloat spriteHeight
    width (String.fromFloat spriteWidth)
    , height (String.fromFloat spriteHeight)
    , x xS
    , y yS
    , class "sprite"
    ]
    [ image [xlinkHref "img/mariosmall.png"] [] ]
 
