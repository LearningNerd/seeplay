module View.Note exposing (drawNote, drawAllNotes)

import Constants
import Model exposing (Model, Margins)
import Msg exposing (..)
import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)
import Animation
import Animation.Messenger
import Array exposing (Array)

import Note exposing (Note)



drawNote : Float -> Margins -> (Animation.Messenger.State Msg) -> Int -> Note -> Svg msg
drawNote lineHeight margins animStyle xPosIndex note =
    let
        yPosFloat =
            toFloat (getNoteHeight note.midi)
    
        cxString =
            String.fromFloat (margins.left + ((toFloat xPosIndex) * (toFloat Constants.noteXInterval) ) )

        cyString =
            String.fromFloat (margins.top + (yPosFloat * lineHeight / 2))
    in
    circle
      ( [ S.cx cxString
        , S.cy cyString
        , S.r (String.fromFloat (lineHeight / 2))
        ] ++ (Animation.render animStyle)
      )
        []


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


drawAllNotes : Float -> Float -> Margins -> (Animation.Messenger.State Msg) -> Array Note -> List (Svg msg)
drawAllNotes staffWidth lineHeight margins animStyle noteList =
    List.indexedMap (drawNote lineHeight margins animStyle) (Array.toList noteList)
-- (List.map toFloat (List.range 1 12))

