module View.Game exposing (view)

import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)
import Array exposing (..)

import ConstantsHelpers
import View.Mario exposing (view)
import View.Coin exposing (view)
import Note exposing (Note)
import Model exposing (Model)
import Msg exposing (..)


view : Model -> Svg Msg
view model =
    let
        widthS = String.fromFloat ConstantsHelpers.svgViewTotalWidth

        heightS = String.fromFloat ConstantsHelpers.svgViewTotalHeight
        
        svgListAllNotes = drawAllTargetNotes model.targetNotes

        xS = String.fromFloat model.playerCurrentXPosition
        yS = String.fromFloat model.playerCurrentYPosition

        currentNoteDrawing = case model.currentNote of
                                 Nothing -> []
                                 Just currentNote -> 
                                   [ View.Mario.view xS yS ]

        -- animate viewBox to scroll game level with all notes drawn inside
        -- updated: draw the current note inside the game level?
        gameLevelSvg = svg [
            S.viewBox (String.fromFloat (model.scrollPosition + ConstantsHelpers.scrollOffset) ++ " 0 " ++ widthS ++ " " ++ heightS)
            , S.width widthS
            , S.height heightS
            , S.x "0", S.y "0"
          ] (currentNoteDrawing ++ svgListAllNotes)
    
    in
      svg
        [ S.width widthS
        , S.height heightS
        , S.viewBox ("0 0 " ++ widthS ++ " " ++ heightS)
        , S.class "center"
        ]
        (
          -- draw 5 staff lines
          (List.map drawStaffLine (List.range 1 5))
           ++ [gameLevelSvg]
           ++ [ trebleClef 0 237 ]
        ) 



drawStaffLine yPos =
    let
        lineYString =
            String.fromFloat (ConstantsHelpers.topMargin + (toFloat yPos * ConstantsHelpers.staffLineHeight))
    in
    line
        [ S.x1 "0"
        , S.y1 lineYString
        , S.x2 (String.fromFloat (ConstantsHelpers.leftMargin + ConstantsHelpers.svgViewWidth))
--        , S.x2 (String.fromFloat staffWidth)
        , S.y2 lineYString
        , S.stroke "black"
        ]
        []



trebleClef x y =
    let
        xS =
            String.fromFloat x

        yS =
            String.fromFloat y
    in
    text_ [ S.x xS, S.y yS, S.class "treble" ] [ HTML.text "𝄞" ]



drawAllTargetNotes : Array Note -> List (Svg msg)
drawAllTargetNotes notes =
    let 
        noteList = Array.toList notes
    in
      List.indexedMap drawTargetNote noteList 

drawTargetNote : Int -> Note -> Svg msg
drawTargetNote xPosIndex note =
    let
        cyString = String.fromFloat (ConstantsHelpers.getNoteYPos note.midi)

        cxString =
            String.fromFloat (ConstantsHelpers.getNoteXPos xPosIndex)
    in
      View.Coin.view cxString cyString

