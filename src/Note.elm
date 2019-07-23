module Note exposing (..)


import Array exposing (..)
import Random
import ConstantsHelpers as Const
import Msg exposing (Msg)


type alias Note =
    { noteName : NoteName -- ("C", 4)
    , midi : Int -- from 21 to 108, for piano
    , frequency : Float
    }


type alias NoteName =
    ( String, Int )


createNote : Int -> Note
createNote midiCode =
    { noteName = midiToNoteName midiCode
    , midi = clamp 21 108 midiCode -- assuming piano MIDI!
    , frequency = midiToFrequency midiCode
    }



getNoteHeightIndex midiCode = 
  let
      -- Map 21 (lowest piano key, A0) to 0, shift all values
      semitoneIndex = remainderBy 12 (midiCode - 21)

      -- ****************************
      -- ****************************
      -- ****************************
      -- ****************************
      
      -- If in the bass clef, shift position down by 3 units
      -- (right now, that's anything below middle C, midi code 60)
      -- note: pos here is bottom to top, where 0 is the lowest,
      -- so the offset is negative (it gets flipped when translating to pixel values)
      shiftBassClef =
        if midiCode < 60 then
           -3
        else
          0

      -- ****************************
      -- ****************************
      -- ****************************
      -- ****************************

      -- Map the chromatic scale (12 semitones) to the diatonic scale (8)
      diatonicIndex = 
        case semitoneIndex of
            0 -> 0 -- A
            1 -> 0 -- A#

            2 -> 1 -- B

            3 -> 2 -- C
            4 -> 2 -- C#

            5 -> 3 -- D
            6 -> 3 -- D#

            7 -> 4 -- E

            8 -> 5 -- F
            9 -> 5 -- F#

            10 -> 6 -- G
            11 -> 6 -- G#

            _ -> 0

      octaveMultiple = (midiCode - 21) // 12
  in
      shiftBassClef + diatonicIndex + (octaveMultiple * 7)


-- position 0 is midiCode 21, at the lowest end of the staff
getNoteY midiCode =
  let
    noteHeightIndex = (getNoteHeightIndex midiCode)
    -- x = Debug.log "totalheight" Const.svgViewTotalHeight
    -- y = Debug.log "lineheight/2" (Const.staffLineHeight/2)
    -- z = Debug.log "noteHeightIndex" noteHeightIndex

    -- b = Debug.log "noteHeightIndex * staffLineHeight/2   " ((toFloat noteHeightIndex) * Const.staffLineHeight / 2)

    -- a = Const.topMargin +
        -- ( Const.svgViewTotalHeight - 
          -- ((toFloat noteHeightIndex) * Const.staffLineHeight / 2)
        -- )
    -- zzz = Debug.log "totalheight - ^   " a

  in
    Const.topMargin +
    ( Const.svgViewTotalHeight - 
      ((toFloat noteHeightIndex) * Const.staffLineHeight / 2)
    )



getNoteX noteIndex =
  Const.leftMargin + ((toFloat noteIndex) * (toFloat Const.noteXInterval) )




-- Generate list of [num] random midi codes
getRandomMidiList : Int -> Random.Generator (List Int)
getRandomMidiList num =
    -- Random.list num <| Random.uniform 60 [64, 67]

    -- BASS TO TREBLE (no ledger lines), including middle C
    Random.list num <| Random.uniform 41 (List.range 42 80)
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

