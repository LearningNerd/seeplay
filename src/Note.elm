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

createNote : Int -> Note
createNote midiCode =
    { noteName = midiToNoteName midiCode
    , midi = clamp 21 108 midiCode -- assuming piano MIDI!
    , frequency = midiToFrequency midiCode
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


getNoteHeightIndex midiCode = 
  let
      -- Map 21 (lowest piano key, A0) to 0, shift all values
      semitoneIndex = remainderBy 12 (midiCode - 21)


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


midiToNoteName : Int -> NoteName
midiToNoteName midiCode =
    let
        pitchClasses =
            Array.fromList
                [ "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B" ]

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

