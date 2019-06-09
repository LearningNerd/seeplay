module View.Mario exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import ConstantsHelpers


-- what was this for again...? =P 
-- sizeOffset = 15


baseSpriteWidth = 17
baseSpriteHeight = 24

widthToHeightRatio = baseSpriteWidth / baseSpriteHeight

-- spriteWidth = (sizeOffset + ConstantsHelpers.staffLineHeight) * widthToHeightRatio
-- spriteHeight = sizeOffset + ConstantsHelpers.staffLineHeight

spriteWidth = (ConstantsHelpers.staffLineHeight) * widthToHeightRatio
spriteHeight = ConstantsHelpers.staffLineHeight


view xS yS =
    svg 
    [ viewBox (String.fromFloat baseSpriteWidth ++ " 0 " ++ String.fromFloat baseSpriteWidth ++ " " ++ String.fromFloat baseSpriteHeight)
    , width (String.fromFloat spriteWidth)
    , height (String.fromFloat spriteHeight)
    , x xS
    , y yS
    , class "sprite"
    ]
    [ image [xlinkHref "img/mariosmall.png"] [] ]
 
