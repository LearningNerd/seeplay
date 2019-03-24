module View.Game exposing (view)

import Config
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
    svgView model Config.svgViewWidth Config.svgViewHeight { top = Config.topMargin, left = Config.leftMargin, bottom = Config.bottomMargin, right = Config.rightMargin }


svgView : Model -> Float -> Float -> Margins -> Svg Msg
svgView model width height margins =
    let
        lineHeight =
            height / 6

        svgWidth =
            Config.svgViewTotalWidth

        widthS = String.fromFloat svgWidth

        heightS =
            String.fromFloat Config.svgViewTotalHeight
        
        drawNoteFunc = View.Note.drawNote lineHeight margins

        svgListAllNotes = View.Note.drawAllNotes width lineHeight margins model.correctNoteStyle model.targetNotes

        -- animate viewBox to scroll game level with all notes drawn inside
        gameLevelSvg = svg ( [S.width widthS, S.height heightS, S.x "150", S.y "0"] ++ Animation.render model.gameLevelScrollState) svgListAllNotes

        currentNoteDrawing = case model.currentNote of
                                 Nothing -> []
                                 Just n -> [ drawNoteFunc model.currentNoteStyle 100 n ]
    in
    svg
        [ S.width widthS
        , S.height heightS
        , S.viewBox ("0 0 " ++ widthS ++ " " ++ heightS)
        , S.class "center"
        ]
        (
          (backgroundStatic width lineHeight margins)
           ++ [gameLevelSvg]
           ++ currentNoteDrawing
        ) 


-- Treble clef and staff are static, other stuff scrolls on top
backgroundStatic width lineHeight margins = 
    (drawStaff width lineHeight margins)
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
            String.fromFloat (margins.top + (toFloat yPos * lineHeight))
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
    List.map (staffLines staffWidth lineHeight margins) (List.range 1 5)

