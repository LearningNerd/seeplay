module Main exposing (..)


import Dict exposing (Dict)
import Array exposing (..)
import Browser
import Random
import Tuple exposing (..)
import Task
import Time
import Animation
import Animation.Messenger
import Html exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)

import Helpers exposing (..)
import Constants
import Model exposing (Model, Score, initialModel)
import Update
import Color
import Animations
import Msg exposing (..)
import Note exposing (Note)
import Ports

import View.Header
import View.MidiStatus
import View.StartScreen
import View.Game
-- TEST:
import View.Coin
import View.Mario


-- TIME HELPER...
displayTimestamp timestamp =
  case timestamp of
        Nothing -> "EMPTY"
        Just t -> String.fromInt (Time.posixToMillis t)

getMillis timestamp =
  case timestamp of
        Nothing -> 0
        Just t -> Time.posixToMillis t



-- VIEW


view : Model -> Html Msg
view model =
    div [ ]
        [ View.Header.view model
        , main_ [A.class "container"] [ Html.p [onClick StartScrollGameLevel ] [ Html.text "....???? test!"] , case model.isMIDIConnected of
            -- If Nothing or False (waiting to init or no MIDI available), then show the MidiStatus screen (waiting for input)
            Nothing ->
              View.MidiStatus.view model
              -- View.Coin.view model
              -- View.Game.view model


            Just False ->
              View.MidiStatus.view model

            Just True ->
              if model.isPlaying
                 then View.Game.view model
                 else View.StartScreen.view model
           ] -- end main 
        ]



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.handleInitMIDI InitMIDI
        , Ports.handleNotePressed NotePressed
        , Ports.handleNoteReleased NoteReleased
        , Time.every 10 TestTick -- every 10 ms
        -- ************************************************
        -- Fake data from fakemidi.js for manual testing:
        -- ************************************************
        , Ports.fakeHandleInitMIDI InitMIDI
        , Ports.fakeHandleNotePressed NotePressed
        , Ports.fakeHandleNoteReleased NoteReleased
        
        , Animation.subscription Animate ( (Dict.values model.uniqueAnimStates) ++ (List.map .animState (Array.toList model.targetNotes)))
        ]



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = Update.update
        , subscriptions = subscriptions
        }

init : Int -> ( Model, Cmd Msg )
init initialSessionId =
    -- Get session ID from JS flag (starts at 0, or incremented from localstorage)
    -- Generate list of random numbers
  ( { initialModel | sessionId = initialSessionId }
    , Random.generate GenerateTargetNotes (Note.getRandomMidiList Constants.notesPerLevel)
  )



updateScore : Int -> Note -> Note -> ( Int, Bool )
updateScore score correctNote currentNote =
    if currentNote.midi == correctNote.midi then
        ( score + 1, True )
    else
        ( score, False )

