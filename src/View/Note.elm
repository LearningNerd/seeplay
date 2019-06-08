module View.Note exposing (..)

import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)
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
            toFloat (Note.getNoteHeight note.midi)
    
        cxString =
            String.fromFloat (margins.left + ((toFloat xPosIndex) * (toFloat Constants.noteXInterval) ) )

        cyString =
            String.fromFloat (margins.top + (yPosFloat * lineHeight / 2))
        
        heightString = (String.fromFloat lineHeight)
    in
      View.Coin.view cxString cyString heightString


drawCurrentNote : Float -> Margins -> Float -> Note -> Svg msg
drawCurrentNote lineHeight margins xPos note =
    let
        cyString = String.fromFloat (getMarioYPosition note.midi)
        cxString = String.fromFloat xPos
    in
      View.Mario.view cxString cyString


getMarioYPosition midiCode =
  let
        yPosFloat =
            toFloat (Note.getNoteHeight midiCode)
  in
    (-1 * View.Mario.sizeOffset) + Constants.topMargin + (yPosFloat * Constants.staffLineHeight/ 2)



drawAllTargetNotes : Float -> Float -> Margins -> Array Note -> List (Svg msg)
drawAllTargetNotes staffWidth lineHeight margins notes =
    let 
        noteList = Array.toList notes
    in
      List.indexedMap (drawTargetNote lineHeight margins) noteList 
-- (List.map toFloat (List.range 1 12))

