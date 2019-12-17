module Msg exposing (Msg(..))

import Time
import Level exposing (Level)

type Msg
    = InitMIDI Bool
    | NotePressed Int
    | NoteReleased Bool
    | StartGame -- triggerd by click in startscreen
    | GenerateTargetNotes (List Int)
    | AnimFrame Time.Posix
    -- TODO: add event for when level is completed

