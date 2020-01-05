module Msg exposing (Msg(..))

import Time
import Level exposing (Level)
import Note exposing (Note)

type Msg
    = InitMIDI Bool
    | NotePressed Int
    | NoteReleased Bool
    | StartGame -- triggerd by click in startscreen
    | GenerateTargetNotes (List Note)
    | AnimFrame Time.Posix
    -- TODO: add event for when level is completed

