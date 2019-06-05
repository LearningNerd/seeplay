module Model exposing (..)

import Dict exposing (Dict)
import Array exposing (..)
import Time

import Msg exposing (..)
import Constants
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

    , scrollPosition: Float
    }

type alias Score =
  { correctNote : Note -- midi code of the Note (not the Note itself!)
  , answerSpeed : Int
  , incorrectTries : Int
  }

-- For views ... not sure where to put this =P
type alias Margins =
    { top : Float, right : Float, bottom : Float, left : Float }


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

    , scrollPosition = 0
    }


