module Msg exposing (Msg(..))

import Time

type Msg
    = InitMIDI Bool
    | NotePressed Int
    | NoteReleased Bool
    | StartGame -- triggerd by click in startscreen
    | GenerateTargetNotes (List Int)
    | AnimFrame Time.Posix

