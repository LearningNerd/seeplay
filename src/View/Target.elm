module View.Target exposing (view, numSpriteFrames)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import ConstantsHelpers
import Msg exposing (Msg)
import Note


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

view : Int -> Int -> Int -> String -> List (Svg Msg)
view xPosIndex midiCode spriteIndex spriteImage =
  let
    xPos = Note.getNoteX xPosIndex
    yPos = Note.getNoteY midiCode

    xOffset = -25
    yOffset = 5
    xP = xPos + xOffset -- center it...?
    yP = yPos + yOffset

    viewBoxStartXString = String.fromInt (spriteIndex * baseSpriteWidth)

    ledgerLineYPositions = Note.getLedgerLineYPositions midiCode

    xyz = Debug.log "ledgerLiiines" ledgerLineYPositions

    ledgerLineMiddleC = 
        if midiCode == 60 then
          (lineTest xP yP)
        else
           text ""

  in
    ( (List.map (lineTest xP) ledgerLineYPositions) ++
      [ svg
        [ viewBox (viewBoxStartXString ++ " 0 " ++ String.fromFloat baseSpriteWidth ++ " " ++ String.fromFloat baseSpriteHeight)
        , width (String.fromFloat spriteWidth)
        , height (String.fromFloat spriteHeight)
        , x (String.fromFloat xP)
        , y (String.fromFloat yP)
        , class "sprite"
        ] [ image [xlinkHref spriteImage] [] ]
    ]
  )

-- where xPos and yPos are the top-left corner of the sprite
lineTest : Float -> Float -> Svg Msg
lineTest xPos yPos =
    line
        [ x1 (String.fromFloat (xPos - spriteWidth/2))
        , y1 (String.fromFloat (yPos + spriteHeight/2))

        , x2 (String.fromFloat (xPos + spriteWidth + spriteWidth/2))
        , y2 (String.fromFloat (yPos + spriteHeight/2))
        , stroke "black"
        ]
        []

