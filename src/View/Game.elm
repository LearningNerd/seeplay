module View.Game exposing (view)

import Model exposing (Model, Margins)
import Msg exposing (..)
import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)

import View.Note

view : Model -> Html Msg
view model =
    svgView model 500 200 { top = 50, left = 50, bottom = 50, right = 50 }


svgView : Model -> Float -> Float -> Margins -> Svg Msg
svgView model width height margins =
    let
        lineHeight =
            height / 6

        widthS =
            String.fromFloat (width + margins.left + margins.right)

        heightS =
            String.fromFloat (height + margins.top + margins.bottom)
        
        drawNoteFunc = View.Note.drawNote width lineHeight margins
        currentNoteDrawing = case model.currentNote of
                                 Nothing -> []
                                 Just n -> [ drawNoteFunc n model.currentNoteStyle ]
    in
    svg
        [ S.width widthS
        , S.height heightS
        , S.viewBox ("0 0 " ++ widthS ++ " " ++ heightS)
        , S.class "center"
        ]
        ((staff width lineHeight margins ++ [drawNoteFunc model.correctNote model.correctNoteStyle])
            ++ currentNoteDrawing ++ [ trebleClef 50 237 ]
        )


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


staff : Float -> Float -> Margins -> List (Svg msg)
staff staffWidth lineHeight margins =
    List.map (staffLines staffWidth lineHeight margins) (List.range 1 5)

