module Model exposing (..)

import Dict exposing (Dict)
import Array exposing (..)
import Time

import Msg exposing (..)
import ConstantsHelpers
import Note exposing (Note)
import Color


type Model = 
  LoadingScreen
  | StartLevelScreen Int
  | Game GameModel

initialModel : Model
initialModel =
  LoadingScreen


type alias Vector =
    { x : Float
    , y: Float
    }

type alias Player = 
    { jumpStartPos : Vector
    , currentPos : Vector
    , velocity : Vector
    , jumpDurationMillis : Float
    , jumpStartTime : Time.Posix
    }

type alias GameModel =
    { targetNotes : Array Note
    , nextTargetNoteIndex : Int
    , currentNote : Maybe Note
    , score : Int
    , levelIndex : Int

    , player : Player
    , nextTargetPos : Vector

------------- for animation: -------------------
    , currentTime : Time.Posix
    , scrollPosition : Float

    , playerSpriteIndex : Int
    , itemSpriteIndex : Int
    , nextFrameTime : Time.Posix -- timestamp of next sprite frame redraw
    }


initialPlayerPos = 
    { x = ConstantsHelpers.playerInitialXPosition
    , y = Note.getNoteY ConstantsHelpers.playerInitialNoteMidi
    }


initialJumpMillis =
  ConstantsHelpers.longJumpDurMillis


initialGameModel : GameModel
initialGameModel =
    { targetNotes = Array.empty
    , nextTargetNoteIndex = 0
    , currentNote = Just (Note.createNoteFromMidi 65)
    , score = 0
    , levelIndex = 0

    , player =
        { jumpStartPos = initialPlayerPos
        , currentPos = initialPlayerPos
        , velocity = {x = 0, y = 0}
        , jumpDurationMillis = initialJumpMillis
        , jumpStartTime = Time.millisToPosix 0 
        }
    , nextTargetPos = initialPlayerPos

------------- for animation: -------------------
    
    , currentTime = Time.millisToPosix 0 
        -- create initial model on game start instead????
    
    , scrollPosition = 0

    , playerSpriteIndex = 0
    , itemSpriteIndex = 0
    , nextFrameTime = Time.millisToPosix 0 
    }

