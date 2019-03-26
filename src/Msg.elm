module Msg exposing (Msg(..))

import Animation
import Time

type Msg
    = InitMIDI Bool
    | NotePressed Int
    | NoteReleased Bool
    | UpdateCorrectNote Int
    | GenerateTargetNotes (List Int)
    | StartGame
    | RestartTimer Time.Posix
   
    | Animate Animation.Msg
    | CorrectNoteFadeAnimCompleted
    | CurrentNoteFadeAnimCompleted
   
    | StartScrollGameLevel
    -- | ScrollGameLevel Animation.Msg

    -- test: delete this!
    | TestTick Time.Posix
    -- | StartSpriteTestAnim
--    | TestSpriteAnim Animation.Msg

