module Example exposing (..)

import Tuple exposing (..)
import Expect exposing (Expectation, FloatingPointTolerance(..))
import Fuzz exposing (Fuzzer, int, list, string, intRange)
import Test exposing (..)

import Main exposing (..)


{--
suite : Test
suite =
    todo "Implement our first test. See https://package.elm-lang.org/packages/elm-explorations/test/latest for how to do this!"
--}

noteDataConversion : Test
noteDataConversion =
  let
      midiCode = 60
  in
    describe "Converting notes"
      [ describe "from MIDI code"

          [ test "to Note Name" <|
              \_ ->
                  midiCode
                      |> midiToNoteName
                      |> Expect.equal ("C", 4)
    
          , test "to frequency in Hz" <|
              \_ ->
                  midiCode
                      |> midiToFrequency
                      |> Expect.within (Relative 0.01) 261.626
          
          , test "to Note record" <|
              \_ ->
                -- NOTE: Expect.all takes a list of expectations and a subject
                -- to pass to all of them as their last argument
                Expect.all [ \x -> Expect.equal ("C", 4) x.noteName
                  , \x -> Expect.equal x.midi midiCode
                  , \x -> Expect.within (Relative 0.01) 261.626 x.frequency
                  ] (createNote midiCode)

          -- y u no work? :(

          {-- fuzz 
          , fuzz (intRange 108 500) "fuzzyyyyy" <|
              \randomMIDICode ->
                  randomMIDICode
                      |> midiToNoteName
                      |> first
                      |> Expect.equal "C"
    --}
            ]
      ]

views : Test
views =
  let
      -- testNothingModel = { isMIDIConnected = Nothing, currenotNote = Nothing }
      testNothing = Nothing
  in
    describe "Displaying view"
      [ describe "for midi connection status"

          [ test "with uninitialized model" <|
              \_ ->
                  displayMIDIStatus testNothing
                      |> Expect.equal "Connect a MIDI instrument to play!"
          ]
      ] 
