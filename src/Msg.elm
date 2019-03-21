module Msg exposing (AnimMsg(..), Msg(..))

import Animation
import Time

type AnimMsg
    = CorrectNoteStyle Animation.Msg
    | CurrentNoteStyle Animation.Msg

type Msg
    = InitMIDI Bool
    | NotePressed Int
    | NoteReleased Bool
    | UpdateCorrectNote Int
    | StartGame
    | RestartTimer Time.Posix
   
    | Animate AnimMsg
    | CorrectNoteFadeAnimCompleted
    | CurrentNoteFadeAnimCompleted
   
    -- test: delete this!
    | TestTick Time.Posix
    | StartSpriteTestAnim
    | TestSpriteAnim Animation.Msg

