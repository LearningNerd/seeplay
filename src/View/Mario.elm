module View.Mario exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import ConstantsHelpers


-- what was this for again...? =P 
-- sizeOffset = 15

numSpriteFrames = 2 -- just using the first 2 sprites for now

baseSpriteWidth = 17
baseSpriteHeight = 24

widthToHeightRatio = baseSpriteWidth / baseSpriteHeight

-- spriteWidth = (sizeOffset + ConstantsHelpers.staffLineHeight) * widthToHeightRatio
-- spriteHeight = sizeOffset + ConstantsHelpers.staffLineHeight

spriteWidth = (ConstantsHelpers.staffLineHeight) * widthToHeightRatio
spriteHeight = ConstantsHelpers.staffLineHeight


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
    [ image [xlinkHref "img/mariosmall.png"] [] ]
 
