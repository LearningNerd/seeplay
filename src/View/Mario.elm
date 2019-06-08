module View.Mario exposing (..)


import Svg exposing (..)
import Svg.Attributes exposing (..)

import Model exposing (Margins)
import Msg exposing (..)
import Constants

sizeOffset = 15

widthToHeightRatio = 17 / 24 -- 17 px wide, 24 px high

baseSpriteWidth = 17
baseSpriteHeight = 24

spriteWidth = (sizeOffset + Constants.staffLineHeight) * widthToHeightRatio
spriteHeight = sizeOffset + Constants.staffLineHeight


-------------- refactor, duplicated in View/Note.elm !!!!!
getMarioXPosition targetNoteIndex =
  let
      test = Debug.log "targetNoteIndex " targetNoteIndex
  in
    Constants.leftMargin
    + ( (toFloat targetNoteIndex) * (toFloat Constants.noteXInterval) )
    - 5


getMarioYPosition midiCode =
  let
        yPosFloat =
            toFloat (getNoteHeight midiCode)
  in
    (-1 * sizeOffset) + Constants.topMargin + (yPosFloat * Constants.staffLineHeight / 2)


getNoteHeight midiCode =
  case midiCode of
    60 -> 11
    62 -> 10
    64 -> 9
    65 -> 8
    67 -> 7
    69 -> 6
    71 -> 5
    72 -> 4
    74 -> 3
    76 -> 2
    77 -> 1
    79 -> 0
    _ -> 12
------------------------------------

-- for now, no viewbox .... will it still work????
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
 
