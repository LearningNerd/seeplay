module View.Game exposing (view)

import Helpers exposing (..)
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

import View.Note

view : Model -> Html Msg
view model =
    svgView model Constants.svgViewWidth Constants.svgViewHeight { top = Constants.topMargin, left = Constants.leftMargin, bottom = Constants.bottomMargin, right = Constants.rightMargin }


svgView : Model -> Float -> Float -> Margins -> Svg Msg
svgView model width height margins =
    let
        currentNoteStyle = getUniqueAnimState model.uniqueAnimStates "currentNoteStyle"
        gameLevelScrollState = getUniqueAnimState model.uniqueAnimStates "gameLevelScrollState"

        svgWidth =
            Constants.svgViewTotalWidth

        widthS = String.fromFloat svgWidth

        heightS =
            String.fromFloat Constants.svgViewTotalHeight
        
        drawTargetNoteFunc = View.Note.drawTargetNote Constants.staffLineHeight margins
        drawCurrentNoteFunc = View.Note.drawCurrentNote Constants.staffLineHeight margins

        svgListAllNotes = View.Note.drawAllTargetNotes width Constants.staffLineHeight margins model.targetNotes

        currentNoteDrawing = case model.currentNote of
                                 Nothing -> []
                                 Just n -> [ drawCurrentNoteFunc currentNoteStyle model.nextTargetNoteIndex n ]

        -- animate viewBox to scroll game level with all notes drawn inside
        -- updated: draw the current note inside the game level?
        gameLevelSvg = svg ( [S.width widthS, S.height heightS, S.x "150", S.y "0"] ++ Animation.render gameLevelScrollState) (currentNoteDrawing ++ svgListAllNotes)
    
    in
    svg
        [ S.width widthS
        , S.height heightS
        , S.viewBox ("0 0 " ++ widthS ++ " " ++ heightS)
        , S.class "center"
        ]
        (
          (backgroundStatic width Constants.staffLineHeight margins)
           ++ [gameLevelSvg]
           -- ++ currentNoteDrawing
        ) 


-- Treble clef and staff are static, other stuff scrolls on top
backgroundStatic width lineHeight margins = 
    (drawStaff width Constants.staffLineHeight margins)
    ++ [ trebleClef 50 237 ]


trebleClef x y =
    let
        xS =
            String.fromFloat x

        yS =
            String.fromFloat y
    in
    text_ [ S.x xS, S.y yS, S.class "treble" ] [ HTML.text "𝄞" ]


staffLines : Float -> Float -> Margins -> Int -> Svg msg
staffLines staffWidth lineHeight margins yPos =
    let
        lineYString =
            String.fromFloat (margins.top + (toFloat yPos * Constants.staffLineHeight))
    in
    line
        [ S.x1 (String.fromFloat margins.left)
        , S.y1 lineYString
        , S.x2 (String.fromFloat (margins.left + staffWidth))
        , S.y2 lineYString
        , S.stroke "black"
        ]
        []


drawStaff : Float -> Float -> Margins -> List (Svg msg)
drawStaff staffWidth lineHeight margins =
    List.map (staffLines staffWidth Constants.staffLineHeight margins) (List.range 1 5)

