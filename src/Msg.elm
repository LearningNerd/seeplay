module Msg exposing (Msg(..))

import Animation
import Time

type Msg
    = InitMIDI Bool
    | NotePressed Int
    | NoteReleased Bool
    
    | GenerateTargetNotes (List Int)
    | StartGame
    | RestartTimer Time.Posix
   
    | Animate Animation.Msg

    | StartScrollGameLevel

    | ScrollToCoinDone Int Int
    | JumpToCoinDone
    | GetCoinDone
--    | ResumeWalkingDone

    -- test: delete this!
    | TestTick Time.Posix

