module Model exposing (..)


import Time
import Msg exposing (..)
import Note exposing (Note)
import Color
import Animations
import Animation
import Animation.Messenger


type alias Model =
    { isMIDIConnected : Maybe Bool
    , isPlaying : Bool
    , correctNote : Note
    , currentNote : Maybe Note
    , score : Int
    , startTimestamp : Maybe Time.Posix
    , answerSpeed : Int -- result of subtracting two times via posixToMillis
    , incorrectTries : Int
    , scoreList : List Score -- store a list of score records for each practice session ... goes into local storage
    , testCurrentTimestamp : Maybe Time.Posix
    , sessionId : Int
    , style : Animation.Messenger.State Msg
    , currentNoteStyle : Animation.Messenger.State Msg
    , correctNoteStyle : Animation.Messenger.State Msg
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
    , correctNote = Note.createNote 60
    , currentNote = Nothing
    , score = 0
    , startTimestamp = Nothing
    , answerSpeed = 0
    , incorrectTries = 0
    , scoreList = []
    , testCurrentTimestamp = Nothing
    , sessionId = 0
    , style = Animation.style [ Animation.opacity 1.0 ]
    , currentNoteStyle = Animations.initialCurrentNoteStyle
    , correctNoteStyle = Animations.initialCorrectNoteStyle
    }

