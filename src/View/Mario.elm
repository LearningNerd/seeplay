module View.Mario exposing (..)


import Animation
import Animation.Messenger
import Svg exposing (..)
import Svg.Attributes exposing (..)

import Model exposing (Margins)
import Msg exposing (..)
import Constants
import Animations exposing (staticSprite, spriteLoop)

sizeOffset = 15

widthToHeightRatio = 17 / 24 -- 17 px wide, 24 px high

baseSpriteWidth = 17
baseSpriteHeight = 24

spriteWidth = (sizeOffset + Constants.staffLineHeight) * widthToHeightRatio
spriteHeight = sizeOffset + Constants.staffLineHeight


marioWalkLoop = spriteLoop 100 baseSpriteWidth baseSpriteHeight 0 2

marioJump midiCode =
  let
      setSprite = staticSprite baseSpriteWidth baseSpriteHeight 2
      yPos = getMarioYPosition midiCode
  in
    setSprite ::
    [ Animation.to [ Animation.y yPos ]
    , Animation.Messenger.send MoveToCoinDone
    ]


marioFall midiCode =
  let
      setSprite = staticSprite baseSpriteWidth baseSpriteHeight 3
      yPos = getMarioYPosition midiCode
  in
    setSprite ::
    [ Animation.to [ Animation.y yPos ]
    , Animation.Messenger.send MoveToCoinDone
    ]


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
view animStyleSprite animStylePos yS =
    svg ( Animation.render animStylePos ++ Animation.render animStyleSprite ++
    [ -- viewBox "0 0 " ++ String.fromFloat spriteWidth ++ " " ++ String.fromFloat spriteHeight
    width (String.fromFloat spriteWidth)
    , height (String.fromFloat spriteHeight)
    , y yS
    , class "sprite"
    ])
    [ image [xlinkHref "img/mariosmall.png"] [] ]
 
