module View.Game exposing (view)

import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)
import Array exposing (..)

import Constants
import View.Mario exposing (view)
import View.Coin exposing (view)
import Note exposing (Note)
import Model exposing (Model)
import Msg exposing (..)


view : Model -> Svg Msg
view model =
    let
        widthS = String.fromFloat Constants.svgViewTotalWidth

        heightS = String.fromFloat Constants.svgViewTotalHeight
        
        svgListAllNotes = drawAllTargetNotes model.targetNotes

        currentNoteDrawing = case model.currentNote of
                                 Nothing -> []
                                 Just currentNote -> [ drawCurrentNote model.playerCurrentXPosition currentNote ]


        -- animate viewBox to scroll game level with all notes drawn inside
        -- updated: draw the current note inside the game level?
        gameLevelSvg = svg [
            S.viewBox (String.fromFloat (model.scrollPosition + Constants.scrollOffset) ++ " 0 " ++ widthS ++ " " ++ heightS)
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
            String.fromFloat (Constants.topMargin + (toFloat yPos * Constants.staffLineHeight))
    in
    line
        [ S.x1 "0"
        , S.y1 lineYString
        , S.x2 (String.fromFloat (Constants.leftMargin + Constants.svgViewWidth))
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


-- Currently, moved this to run in the animation loop (update on every frame)
-- getNoteXPos noteIndex =
  -- String.fromFloat (Constants.leftMargin + ((toFloat noteIndex) * (toFloat Constants.noteXInterval) ) )


getNoteYPos midiCode =
  let
    yPosFloat = toFloat (Note.getHeight midiCode)
  in
    String.fromFloat (Constants.topMargin + (yPosFloat * Constants.staffLineHeight / 2))


drawTargetNote : Int -> Note -> Svg msg
drawTargetNote xPosIndex note =
    let
        cyString = getNoteYPos note.midi

        cxString =
            String.fromFloat (Constants.leftMargin + ((toFloat xPosIndex) * (toFloat Constants.noteXInterval) ) )

        heightString = (String.fromFloat Constants.staffLineHeight)
    in
      View.Coin.view cxString cyString heightString



drawAllTargetNotes : Array Note -> List (Svg msg)
drawAllTargetNotes notes =
    let 
        noteList = Array.toList notes
    in
      List.indexedMap drawTargetNote noteList 


drawCurrentNote : Float -> Note -> Svg msg
drawCurrentNote xPos note =
    let
        cyString = getNoteYPos note.midi
        cxString = String.fromFloat xPos
    in
      View.Mario.view cxString cyString

