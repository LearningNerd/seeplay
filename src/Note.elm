module Note exposing (..)


import Array exposing (..)
import Random
import ConstantsHelpers as Const


type alias Note =
    { noteName : NoteName -- ("C", 4)
    , midi : Int -- from 21 to 108, for piano
    , frequency : Float
    }


type alias NoteName =
    ( String, Int )


createNoteFromMidi : Int -> Note
createNoteFromMidi midiCode =
    { noteName = getNoteNameFromMidi midiCode
    , midi = clamp 21 108 midiCode -- assuming piano MIDI!
    , frequency = getFrequencyFromMidi midiCode
    }

createNoteFromNoteName : NoteName -> Note
createNoteFromNoteName noteName =
  let
      midiCode = getMidiFromNoteName noteName
  in
     { noteName = noteName
     , midi = midiCode
     , frequency = getFrequencyFromMidi midiCode
   }


getOctaveShift : Int -> String
getOctaveShift midiCode =
  if midiCode > 102 then -- 15ma
    "15ma"
  else if midiCode > 90 then -- 8va
    "8va"
  else if midiCode > 30 then -- all normal notes
    ""
  else 
    "8vb"

getDiatonicIndexFromMidi : Int -> Int
getDiatonicIndexFromMidi midiCode =
  let
      -- Note: midi code 0 is C, and 21 (the lowest "real" note) correctly maps to A
      chromaticIndex = remainderBy 12 midiCode
  in
      -- Map the chromatic scale (12 semitones) to the diatonic scale (8)
        case chromaticIndex of
            0 -> 0 -- C
            1 -> 0 -- C#
            2 -> 1 -- D
            3 -> 1 -- D#
            4 -> 2 -- E
            5 -> 3 -- F
            6 -> 3 -- F#
            7 -> 4 -- G
            8 -> 4 -- G#
            9 -> 5 -- A
            10 -> 5 -- A#
            11 -> 6 -- B
            _ -> 0


-- Convert from note name ("C" etc) to 0 to 11 from chromatic scale
getChromaticIndexFromPitchClass : String -> Int
getChromaticIndexFromPitchClass pitchClass =
  -- Note: Starting with C because naming convention starts as A0, B0, C1, ... new octave multiple on every C
  case pitchClass of
    "C" -> 0
    "C#" -> 1
    "D" -> 2
    "D#" -> 3
    "E" -> 4
    "F" -> 5
    "F#" -> 6
    "G" -> 7
    "G#" -> 8
    "A" -> 9
    "A#" -> 10
    "B" -> 11
    _ -> 0


-- Convert index from 0 to 11 from chromatic scale to pitch class letter
getPitchClassFromChromaticIndex : Int -> String
getPitchClassFromChromaticIndex noteIndex =
  case noteIndex of
    0 -> "C"
    1 -> "C#"
    2 -> "D"
    3 -> "D#"
    4 -> "E"
    5 -> "F"
    6 -> "F#"
    7 -> "G"
    8 -> "G#"
    9 -> "A"
    10 -> "A#"
    11 -> "B"
    _ -> "C"


getMidiFromNoteName : NoteName -> Int
getMidiFromNoteName (pitchClass, octaveMultiple) =
  let
      chromaticIndex = getChromaticIndexFromPitchClass pitchClass
  in
      chromaticIndex + ( (octaveMultiple + 1) * 12)



getNoteHeightIndex midiCode = 
  let
      -- Map 21 (lowest piano key, A0) to 0, shift all values
      diatonicIndex = getDiatonicIndexFromMidi midiCode
      octaveMultiple = (midiCode - 21) // 12

      -- If in the bass clef, shift position down by 3 units
      -- (right now, that's anything below middle C, midi code 60)
      -- note: pos here is bottom to top, where 0 is the lowest,
      -- so the offset is negative (it gets flipped when translating to pixel values)
{--
      shiftBassClef =
        if midiCode < 60 then
           -4
        else
          0
--}
      -- for now, no extra gap between clefs
      shiftBassClef = 0

      originalHeightIndex = shiftBassClef + diatonicIndex + (octaveMultiple * 7)
  in
     case (getOctaveShift midiCode) of
       "15ma" ->
          originalHeightIndex - 14
       "8va" ->
          originalHeightIndex - 7
       "8vb" ->
        originalHeightIndex + 7
       _ ->
         originalHeightIndex


-- Given the note height index (from getNoteHeightIndex),
-- return a list of note height indeces of each ledger line
-- to be drawn for a given note
getLedgerLineHeightIndeces noteHeightIndex =
  let
    trebleLedgerLines = [35, 37, 39]
    bassLedgerLines = [11, 9, 7]
    middleC = [23]
  in
      if noteHeightIndex > 34 then
         trebleLedgerLines
            |> List.take (1 + (noteHeightIndex - 35) // 2)

      else if noteHeightIndex < 12 then
         bassLedgerLines
            |> List.take (1 + (11 - noteHeightIndex) // 2)
      
      else if noteHeightIndex == 23 then
        middleC

      else
        []


getYPos heightIndex =
  let
      -- By not drawing all bottom ledger lines (using 8vb instead), all height indeces visually shift up)
      visualHeightIndex = heightIndex - 4
  in
    Const.topMargin +
    ( Const.svgViewTotalHeight - 
      ((toFloat visualHeightIndex) * Const.staffLineHeight / 2)
    )


getLedgerLineYPositions midiCode =
  let
    lineHeightIndeces = 
      getLedgerLineHeightIndeces
        <| getNoteHeightIndex midiCode
  in
    List.map getYPos lineHeightIndeces



-- position 0 is midiCode 21, at the lowest end of the staff
getNoteY midiCode =
  let
    noteHeightIndex = (getNoteHeightIndex midiCode)
  in
    getYPos noteHeightIndex


getNoteX xPosIndex =
  Const.leftMargin + ((toFloat xPosIndex) * (toFloat Const.noteXInterval) )



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


getNoteNameFromMidi : Int -> NoteName
getNoteNameFromMidi midiCode =
  let
      index = remainderBy 12 midiCode
      pitchClass = getPitchClassFromChromaticIndex index
      octave = (midiCode // 12) - 1   -- from 0 to 8
  in
     ( pitchClass, octave )


getFrequencyFromMidi : Int -> Float
getFrequencyFromMidi midiCode =
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

