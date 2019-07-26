module View.Game exposing (view)

import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)
import Array exposing (..)

import ConstantsHelpers as Const
import View.Player exposing (view)
import View.Target exposing (view)
import View.Staff
import Note exposing (Note)
import Model exposing (GameModel)
import Msg exposing (..)


view : GameModel -> Svg Msg
view model =
    let
        widthS = String.fromFloat Const.svgViewTotalWidth

        heightS = String.fromFloat Const.svgViewTotalHeight
        
        svgListAllNotes = drawAllTargetNotes model.itemSpriteIndex model.nextTargetNoteIndex model.targetNotes

        x = model.player.currentPos.x
        y = model.player.currentPos.y

        currentNoteDrawing =
            case model.currentNote of
                Nothing ->
                  []
                Just currentNote -> 
                  [View.Player.view x y model.playerSpriteIndex]

        -- animate viewBox to scroll game level with all notes drawn inside
        -- updated: draw the current note inside the game level?
        gameLevelSvg = 
          svg
          [
            S.viewBox (String.fromFloat (model.scrollPosition + Const.scrollOffset) ++ " 0 " ++ widthS ++ " " ++ heightS)
            , S.width widthS
            , S.height heightS
            , S.x "0", S.y "0"
          ] (svgListAllNotes ++ currentNoteDrawing)
    
    in
      svg
        [ -- S.width widthS
        --, S.height heightS
        S.viewBox ("0 0 " ++ widthS ++ " " ++ heightS)
        , S.class "center"
        ]
        (
          View.Staff.view ++ [gameLevelSvg]
        ) 




drawAllTargetNotes : Int -> Int -> Array Note -> List (Svg Msg)
drawAllTargetNotes spriteIndex nextTargetNoteIndex notes =
    let 
        noteList = Array.toList notes
    in
      List.concat <| List.indexedMap (drawTargetNote spriteIndex nextTargetNoteIndex) noteList 


-- Return a list containing the note sprite AND ledger line
-- (if applicable)
drawTargetNote : Int -> Int -> Int -> Note -> List (Svg Msg)
drawTargetNote spriteIndex nextTargetNoteIndex xPosIndex note =
    let
        spriteImage = 
          if xPosIndex > (nextTargetNoteIndex - 1) then -- future notes are "next targets"
            Const.nextTargetSpriteImage
          else
            Const.correctTargetSpriteImage -- prev/cur notes are correct
    in
      View.Target.view xPosIndex note.midi spriteIndex spriteImage

