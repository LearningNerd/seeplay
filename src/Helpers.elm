module Helpers exposing (..)


import Array
import Dict exposing (Dict)
import Animation
import Animation.Messenger


-- get the value of a dictionary entry
getUniqueAnimState dict key =
  Maybe.withDefault (Animation.style []) (Dict.get key dict)


-- return a dictionary with an updated value
updateUniqueAnimState dict (key, newValue) =
  Dict.update key (Maybe.map (\a -> newValue)) dict


-- returns a dictionary of keys mapped to (newStyle, cmd) tuples!
updateEveryAnimState dict timestamp =
  let
      animEach key val =
        Animation.Messenger.update timestamp val
  in
    Dict.map animEach dict

-- example: "correctNoteStyle" [Animation.to [Animation.opacity 1.0]]
-- return updated model!
updateModelForUniqueAnim model animKey newAnimSteps = 
  let
    currentStyle = getUniqueAnimState model.uniqueAnimStates animKey
    newStyle = Animation.interrupt newAnimSteps currentStyle
  in
    { model | uniqueAnimStates = updateUniqueAnimState model.uniqueAnimStates (animKey, newStyle) }



-- returns (newNote, cmd)
updateNoteWithAnimState timestamp note =
  let
      (newAnimState, cmd) = Animation.Messenger.update timestamp note.animState
      newNote = { note | animState = newAnimState }
  in
     (newNote, cmd)

-- returns ( [list of updated notes], [list of cmds] )
-- updateAllNotesAnimStates timestamp notesList =
  -- List.unzip (List.map (updateNoteWithAnimState timestamp) notesList))


updateNoteWithAnimSteps animStepsList note =
  { note | animState = Animation.interrupt animStepsList note.animState }

startAnimEveryNote noteList animStepsList =
  let
      notes = Array.toList noteList
  in
    Array.fromList <| List.map (updateNoteWithAnimSteps animStepsList) notes

