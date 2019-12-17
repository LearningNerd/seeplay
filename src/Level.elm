module Level exposing (..)


import Note exposing (Note)
import Array exposing (..)


type alias Level =
    { rootMidi : Int
    , maxInterval : Int -- example: +- from 0 to 3
    }

-- NOTE: not using this right now ... defined generateRandomTargetNotes in Update.elm instead for now
-- Initialize array of target notes based on the current level
generateTargetNotes : Level -> List Int -> Array Note
generateTargetNotes gameLevel intervalList =
  intervalList
    |> List.map (\n -> gameLevel.rootMidi + n)
    |> List.map Note.createNote
    |> Array.fromList

