module View.Staff exposing (view)


import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)
import Array exposing (..)

import ConstantsHelpers as Const
import View.Player exposing (view)
import View.Target exposing (view)
import Note exposing (Note)
import Model exposing (GameModel)
import Msg exposing (..)


-- draw 5 staff lines ............
view : List (Svg Msg)
view =
  (
    ---------------   treble ledger lines
    ---------------   pos 51 to 35
    List.map (drawStaffLine "white") (List.range 1 9)
    ++ 
    ---------------   TREBLE
    ---------------   pos 64  to 33
    List.map (drawStaffLine "black") (List.range 10 14)
    ++
    ---------------   MIDDLE C and gap between treble and bass clefs
    ---------------   pos 23 (MIDI 60)
    List.map (drawStaffLine "white") (List.range 15 17)
    ++
    ---------------   BASS
    ---------------   pos 21 to 13
    List.map (drawStaffLine "black") (List.range 18 21)
    ++
    ---------------   bass ledger lines
    ---------------   pos 11 to 1
    List.map (drawStaffLine "white") (List.range 22 27)
  )

-- remove for now, need to redo as an SVG shape instead of text
    -- and size/position it dynamically....
    -- .... same for bass clef
    -- ++ [trebleClef]


drawStaffLine colorString yPos =
    let
        lineYString =
            String.fromFloat (Const.topMargin + (toFloat yPos * Const.staffLineHeight))
    in
    line
        [ S.x1 "0"
        , S.y1 lineYString
        , S.x2 (String.fromFloat (Const.svgViewTotalWidth))
--        , S.x2 (String.fromFloat staffWidth)
        , S.y2 lineYString
        , S.stroke colorString
        ]
        []


trebleClef =
    let
        xS =
            String.fromFloat Const.trebleLeftMargin

        yS =
            String.fromFloat (Const.topMargin + (Const.staffLineHeight * 5.75))

        fontSizeS = String.fromFloat (Const.svgViewWidth * 0.4214)
    in
    text_ [ S.x xS, S.y yS, S.fontSize fontSizeS ] [ HTML.text "𝄞" ]

