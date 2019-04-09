module View.Note exposing (..)

import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)
import Animation
import Animation.Messenger
import Array exposing (Array)

import Constants
import Model exposing (Model, Margins)
import Msg exposing (..)
import Note exposing (Note)
import View.Coin exposing (view)
import View.Mario exposing (view)


drawTargetNote : Float -> Margins -> Int -> Note -> Svg msg
drawTargetNote lineHeight margins xPosIndex note =
    let
        yPosFloat =
            toFloat (getNoteHeight note.midi)
    
        cxString =
            String.fromFloat (margins.left + ((toFloat xPosIndex) * (toFloat Constants.noteXInterval) ) )

        cyString =
            String.fromFloat (margins.top + (yPosFloat * lineHeight / 2))
        
        heightString = (String.fromFloat lineHeight)
    in
      View.Coin.view note.animState cxString cyString heightString

{--
    circle
      ( [ S.cx cxString
        , S.cy cyString
        , S.r (String.fromFloat (lineHeight / 2))
        ] ++ (Animation.render animStyle)
      )
        []
--}


drawCurrentNote : Float -> Margins -> (Animation.Messenger.State Msg) -> (Animation.Messenger.State Msg) -> Int -> Note -> Svg msg
drawCurrentNote lineHeight margins animStyleSprite animStylePos xPosIndex note =
    let
    
        -- cxString =
            -- String.fromFloat (margins.left + ((toFloat xPosIndex) * (toFloat Constants.noteXInterval) ) + 12 )

        cyString = String.fromFloat (getMarioYPosition note.midi)
    in
      View.Mario.view animStyleSprite animStylePos cyString


getMarioYPosition midiCode =
  let
        yPosFloat =
            toFloat (getNoteHeight midiCode)
  in
    (-1 * View.Mario.sizeOffset) + Constants.topMargin + (yPosFloat * Constants.staffLineHeight/ 2)


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



{--
getNoteHeight midiCode = 
  case midiCode of
    60 -> 12
    62 -> 11
    64 -> 10
    65 -> 9
    67 -> 8
    69 -> 7
    71 -> 6
    72 -> 5
    74 -> 4
    76 -> 3
    77 -> 2
    79 -> 1
    _ -> 12
--}

drawAllTargetNotes : Float -> Float -> Margins -> Array Note -> List (Svg msg)
drawAllTargetNotes staffWidth lineHeight margins notes =
    let 
        noteList = Array.toList notes
    in
      List.indexedMap (drawTargetNote lineHeight margins) noteList 
-- (List.map toFloat (List.range 1 12))

