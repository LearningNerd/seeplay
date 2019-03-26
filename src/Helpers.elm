module Helpers exposing (..)


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


