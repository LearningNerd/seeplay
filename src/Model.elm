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


type alias GameModel =
    { targetNotes : Array Note
    , nextTargetNoteIndex : Int
    , currentNote : Maybe Note
    , score : Int

------------- for animation: -------------------
    , playerJumpStartXPosition : Float
    , playerJumpStartYPosition : Float

    , playerCurrentXPosition : Float
    , playerCurrentYPosition : Float

    , nextTargetXPosition : Float
    , nextTargetYPosition : Float
    , velocityX : Float
    , velocityY : Float
    , jumpDurationMillis : Float

    , millisSinceJumpStarted : Float
    , scrollPosition : Float

    , playerSpriteIndex : Int
    , itemSpriteIndex : Int
    , millisSinceLastSpriteAnimFrame : Float
    }


initialGameModel : GameModel
initialGameModel =
    { targetNotes = Array.empty
    , nextTargetNoteIndex = 0
    , currentNote = Just (Note.createNote 65)
    , score = 0

------------- for animation: -------------------
    , playerJumpStartXPosition = ConstantsHelpers.playerInitialXPosition
    , playerJumpStartYPosition = ConstantsHelpers.getNoteYPos ConstantsHelpers.playerInitialNote

    , playerCurrentXPosition = ConstantsHelpers.playerInitialXPosition
    , playerCurrentYPosition = ConstantsHelpers.getNoteYPos ConstantsHelpers.playerInitialNote

    , nextTargetXPosition = ConstantsHelpers.playerInitialXPosition
    , nextTargetYPosition = ConstantsHelpers.getNoteYPos ConstantsHelpers.playerInitialNote

    , velocityX = 0
    , velocityY = 0
    , jumpDurationMillis = ConstantsHelpers.convertFramesToMillisDuration ConstantsHelpers.defaultJumpDurationFrames ConstantsHelpers.framesPerSecond

    , millisSinceJumpStarted = ConstantsHelpers.convertFramesToMillisDuration ConstantsHelpers.defaultJumpDurationFrames ConstantsHelpers.framesPerSecond
    , scrollPosition = 0

    , playerSpriteIndex = 0
    , itemSpriteIndex = 0
    , millisSinceLastSpriteAnimFrame = 0
    }


