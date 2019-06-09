module Model exposing (..)

import Dict exposing (Dict)
import Array exposing (..)
import Time

import Msg exposing (..)
import ConstantsHelpers
import Note exposing (Note)
import Color


type alias Model =
    { isMIDIConnected : Maybe Bool
    , isPlaying : Bool

    , targetNotes : Array Note
    , nextTargetNoteIndex : Int
    , currentNote : Maybe Note
    , prevMidi : Maybe Int
    
    , score : Int
    , startTimestamp : Maybe Time.Posix
    , answerSpeed : Int -- result of subtracting two times via posixToMillis
    , incorrectTries : Int
    , scoreList : List Score -- store a list of score records for each practice session ... goes into local storage
    , sessionId : Int

------------- for animation: -------------------
    , playerJumpStartXPosition : Float
    , playerJumpStartYPosition : Float

    , playerCurrentXPosition : Float
    , playerCurrentYPosition : Float

    , nextTargetXPosition : Float
    , nextTargetYPosition : Float
    , velocityX : Float
    , velocityY : Float

    , millisSinceJumpStarted : Float
    , scrollPosition : Float

    , playerSpriteIndex : Int
    }

type alias Score =
  { correctNote : Note -- midi code of the Note (not the Note itself!)
  , answerSpeed : Int
  , incorrectTries : Int
  }


initialModel : Model
initialModel =
    { isMIDIConnected = Nothing
    , isPlaying = False
    
    , targetNotes = Array.empty
    , nextTargetNoteIndex = 0
    , currentNote = Just (Note.createNote 65)
    , prevMidi = Nothing
    
    , score = 0
    , startTimestamp = Nothing
    , answerSpeed = 0
    , incorrectTries = 0
    , scoreList = []
    , sessionId = 0

------------- for animation: -------------------
    , playerJumpStartXPosition = ConstantsHelpers.playerInitialXPosition
    , playerJumpStartYPosition = ConstantsHelpers.getNoteYPos ConstantsHelpers.playerInitialNote

    , playerCurrentXPosition = ConstantsHelpers.playerInitialXPosition
    , playerCurrentYPosition = ConstantsHelpers.getNoteYPos ConstantsHelpers.playerInitialNote

    , nextTargetXPosition = ConstantsHelpers.playerInitialXPosition
    , nextTargetYPosition = ConstantsHelpers.getNoteYPos ConstantsHelpers.playerInitialNote

    , velocityX = 0
    , velocityY = 0
    , millisSinceJumpStarted = ConstantsHelpers.jumpDurationMillis
    , scrollPosition = 0

    , playerSpriteIndex = 0
    }


