module View.Target exposing (view, numSpriteFrames)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import ConstantsHelpers


{-- coin sprite dimensions:
numSpriteFrames = 4
baseSpriteWidth = 16
baseSpriteHeight = 16
--}


numSpriteFrames = 5

baseSpriteWidth = 59
baseSpriteHeight = 44

widthToHeightRatio = baseSpriteWidth / baseSpriteHeight


spriteWidth = (ConstantsHelpers.staffLineHeight * 1) * widthToHeightRatio
spriteHeight = ConstantsHelpers.staffLineHeight * 1

{--
spriteWidth = (ConstantsHelpers.staffLineHeight * 0.8) * widthToHeightRatio
spriteHeight = ConstantsHelpers.staffLineHeight * 0.8
--}

view xPos yPos spriteIndex spriteImage =
  let
    viewBoxStartXString = String.fromInt (spriteIndex * baseSpriteWidth)
    xS = String.fromFloat (xPos - 25) -- center it...?
    yS = String.fromFloat (yPos + 5)
  in
    svg
    [ viewBox (viewBoxStartXString ++ " 0 " ++ String.fromFloat baseSpriteWidth ++ " " ++ String.fromFloat baseSpriteHeight)
    , width (String.fromFloat spriteWidth)
    , height (String.fromFloat spriteHeight)
    , x xS
    , y yS
    , class "sprite"
    ]
    [ image [xlinkHref spriteImage] [] ]


lineTest xPosFloat yPosString =
    line
        [ x1 (String.fromFloat xPosFloat)
        , y1 yPosString
        , x2 (String.fromFloat (xPosFloat + 50))
        , y2 yPosString
        , stroke "black"
        ]
        []

