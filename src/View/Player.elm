module View.Player exposing (view, numSpriteFrames)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import ConstantsHelpers


numSpriteFrames = 4 

baseSpriteWidth = 12
baseSpriteHeight = 11


widthToHeightRatio = baseSpriteWidth / baseSpriteHeight

spriteWidth = (ConstantsHelpers.staffLineHeight * 0.9) * widthToHeightRatio
spriteHeight = ConstantsHelpers.staffLineHeight * 0.9


view xPos yPos spriteIndex =
  let
      viewBoxStartXString = String.fromInt (spriteIndex * baseSpriteWidth)
      xS = String.fromFloat xPos
      yS = String.fromFloat (yPos - 3)
  in
    svg 
    [ viewBox (viewBoxStartXString ++ " 0 " ++ String.fromFloat baseSpriteWidth ++ " " ++ String.fromFloat baseSpriteHeight)
    , width (String.fromFloat spriteWidth)
    , height (String.fromFloat spriteHeight)
    , x xS
    , y yS
    , class "sprite"
    ]
    [ image [xlinkHref "img/ice-idlejump-12w-11h-4i.png"] [] ]
 
