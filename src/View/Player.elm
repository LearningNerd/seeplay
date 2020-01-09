module View.Player exposing (view, numSpriteFrames)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import ConstantsHelpers
import Msg exposing (Msg)
import Note


numSpriteFrames = 4 

baseSpriteWidth = 12
baseSpriteHeight = 11


widthToHeightRatio = baseSpriteWidth / baseSpriteHeight

spriteWidth = (ConstantsHelpers.staffLineHeight * 0.5) * widthToHeightRatio
spriteHeight = ConstantsHelpers.staffLineHeight * 0.5


view : Float -> Float -> Int -> Int -> Bool -> List (Svg Msg)
view xPos yPos midiCode spriteIndex isOnCurrentNote =
  let
      viewBoxStartXString = String.fromInt (spriteIndex * baseSpriteWidth)
      xS = String.fromFloat xPos
      
      yS = String.fromFloat (yPos + 13)

      ledgerLineYPositions = Note.getLedgerLineYPositions midiCode

      octaveShift = 
        text_
          [ x (String.fromFloat (xPos + spriteWidth/2))
          , y (String.fromFloat (yPos - 15) )
          , textAnchor "middle"
          , class "octaveShift"
          ]
          [text (Note.getOctaveShift midiCode)] 

      -- Only draw ledger line(s)/8va stuff if player is NOT already on top of current target note, so we don't draw the notation twice (which looks buggy, blech!)
      extraNoteDecorations =
        case isOnCurrentNote of
          True ->
            []
          False ->
            [octaveShift] ++ (List.map (drawLedgerLine xPos) ledgerLineYPositions)
  in
    ( extraNoteDecorations ++
      [ svg
        [ viewBox (viewBoxStartXString ++ " 0 " ++ String.fromFloat baseSpriteWidth ++ " " ++ String.fromFloat baseSpriteHeight)
        , width (String.fromFloat spriteWidth)
        , height (String.fromFloat spriteHeight)
        , x xS
        , y yS
        , class "sprite"
        ] [ image [xlinkHref "img/ice-idlejump-12w-11h-4i.png"] [] ]
    ]
  )


-- where xPos and yPos are the top-left corner of the sprite
drawLedgerLine: Float -> Float -> Svg Msg
drawLedgerLine xPos yPos =
    line
        [ x1 (String.fromFloat (xPos - spriteWidth/2))
        , y1 (String.fromFloat (yPos + spriteHeight/2))

        , x2 (String.fromFloat (xPos + spriteWidth + spriteWidth/2))
        , y2 (String.fromFloat (yPos + spriteHeight/2))
        , stroke "black"
        ]
        []

