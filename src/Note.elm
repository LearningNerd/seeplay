module Note exposing (..)


import Array exposing (..)
import Random

import Msg exposing (Msg)


type alias Note =
    { noteName : NoteName -- ("C", 4)
    , midi : Int -- from 21 to 108, for piano
    , frequency : Float
    

    -- , animState : Animation.Messenger.State Msg
    }


type alias NoteName =
    ( String, Int )


createNote : Int -> Note
createNote midiCode =
    { noteName = midiToNoteName midiCode
    , midi = clamp 21 108 midiCode -- assuming piano MIDI!
    , frequency = midiToFrequency midiCode
    }


getNoteHeight midiCode = 
  case midiCode of
    60 -> 11
    62 -> 10
    64 -> 9
    65 -> 8
    67 -> 7
    69 -> 6
    71 -> 5
    72 -> 4
    74 -> 3
    76 -> 2
    77 -> 1
    79 -> 0
    _ -> 12


-- Generate list of [num] random midi codes
getRandomMidiList : Int -> Random.Generator (List Int)
getRandomMidiList num =
    Random.list num <| Random.uniform 60 [64, 67]
{--
  Random.list num <| Random.uniform 60 [ 62
   , 64
   , 65
   , 67
   , 69
   , 71
   , 72
   , 74
   , 76
   , 77
   , 79
   ]
--}

getRandomMidi : Random.Generator Int
getRandomMidi =
  Random.uniform 60 [
    62,
    64,
    65,
    67,
    69,
    71,
    72,
    74,
    76,
    77,
    79]


midiToNoteName : Int -> NoteName
midiToNoteName midiCode =
    let
        pitchClasses =
            Array.fromList
                [ "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B" ]

        index =
            remainderBy 12 midiCode

        pitchClass =
            case Array.get index pitchClasses of
                Nothing ->
                    "C"

                -- if index out of bounds (impastable!!)
                Just x ->
                    x

        octave =
            (midiCode // 12) - 1
    in
    ( pitchClass, octave )


midiToFrequency : Int -> Float
midiToFrequency midiCode =
    let
        -- 2 ^ (1/12) is the frequency ratio of each note...????
        semitoneRatio =
            1.0594630943592953

        -- MIDI code 0 starts at about 8 Hz frequency
        lowestFreq =
            8.1757989156
    in
    lowestFreq * (semitoneRatio ^ toFloat midiCode)


-- Sources: https://en.wikipedia.org/wiki/Pitch_(music)#Labeling_pitches
-- http://subsynth.sourceforge.net/midinote2freq.html
-- and https://newt.phys.unsw.edu.au/jw/notes.html

