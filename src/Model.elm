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
  | StartScreen
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
    }

type alias GameModel =
    { targetNotes : Array Note
    , nextTargetNoteIndex : Int
    , currentNote : Maybe Note
    , score : Int

    , player : Player
    , nextTargetPos : Vector

------------- for animation: -------------------
    , millisSinceJumpStarted : Float

    , scrollPosition : Float

    , playerSpriteIndex : Int
    , itemSpriteIndex : Int
    , millisSinceLastSpriteAnimFrame : Float
    }


initialPlayerPos = 
    { x = ConstantsHelpers.playerInitialXPosition
    , y = ConstantsHelpers.getNoteYPos ConstantsHelpers.playerInitialNote
    }


initialJumpMillis =
  ConstantsHelpers.longJumpDurMillis


initialGameModel : GameModel
initialGameModel =
    { targetNotes = Array.empty
    , nextTargetNoteIndex = 0
    , currentNote = Just (Note.createNote 65)
    , score = 0

    , player =
        { jumpStartPos = initialPlayerPos
        , currentPos = initialPlayerPos
        , velocity = {x = 0, y = 0}
        , jumpDurationMillis = initialJumpMillis
        }
    , nextTargetPos = initialPlayerPos

------------- for animation: -------------------
    , millisSinceJumpStarted = initialJumpMillis
    
    , scrollPosition = 0

    , playerSpriteIndex = 0
    , itemSpriteIndex = 0
    , millisSinceLastSpriteAnimFrame = 0
    }

