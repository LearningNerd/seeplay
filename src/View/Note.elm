module View.Note exposing (drawNote)

import Model exposing (Model, Margins)
import Msg exposing (..)
import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)
import Animation
import Animation.Messenger

import Note exposing (Note)


drawNote : Float -> Float -> Margins -> Note -> (Animation.Messenger.State Msg) -> Svg msg
drawNote staffWidth lineHeight margins note animStyle =
    let
        yPosFloat =
            toFloat (getNoteHeight note.midi)
    
        cxString =
            String.fromFloat (staffWidth/2)

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


{--

allNotes : Float -> Float -> Margins -> List (Svg msg)
allNotes staffWidth lineHeight margins =
    List.map (drawNote staffWidth lineHeight margins) (List.range 60 60)
--}
-- (List.map toFloat (List.range 1 12))

