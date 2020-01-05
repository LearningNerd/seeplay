module Level exposing (..)


import Random
import Array
import Note exposing (Note)


type alias Level =
    { rootNote : Note
    , maxInterval : Int -- example: +- from 0 to 3
    }

-- Hard-coded levels:
levels =
  Array.fromList
    [ { rootNote = Note.createNoteFromMidi 60, maxInterval = 1 }
    , { rootNote = Note.createNoteFromMidi 60, maxInterval = 2 }
    , { rootNote = Note.createNoteFromMidi 67, maxInterval = 1 }
    , { rootNote = Note.createNoteFromMidi 67, maxInterval = 2 }
    , { rootNote = Note.createNoteFromMidi 60, maxInterval = 3 }
    , { rootNote = Note.createNoteFromMidi 67, maxInterval = 3 }
    , { rootNote = Note.createNoteFromMidi 60, maxInterval = 4 }
    , { rootNote = Note.createNoteFromMidi 67, maxInterval = 4 }
    ]

-- Note: uses hard-coded levels above
getLevel : Int -> Level
getLevel levelIndex =
  case (Array.get levelIndex levels) of
    -- Default:
    Nothing ->
      { rootNote = Note.createNoteFromMidi 60
      , maxInterval = 1
      } 
    Just level ->
      level



-- Generate list of random target notes for a given level
generateTargetNotes : Int -> Level -> Random.Generator (List Note)
generateTargetNotes listLength level =
  let
      minValue = -level.maxInterval
      maxValue = level.maxInterval
  in
      Random.int minValue maxValue
        |> Random.map (Note.transposeNoteDiatonic level.rootNote)
        |> Random.list listLength

