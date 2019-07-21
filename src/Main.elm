module Main exposing (..)


import Dict exposing (Dict)
import Array exposing (..)
import Browser
import Browser.Events
import Random
import Tuple exposing (..)
import Task
import Time
import Html exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)

import ConstantsHelpers
import Model exposing (Model(..), GameModel, initialModel)
import Update
import Color
import Msg exposing (..)
import Note exposing (Note)
import Ports

import View.Header
import View.MidiStatus
import View.StartScreen
import View.Game
-- TEST:
import View.Target
import View.Player



-- VIEW


view : Model -> Html Msg
view model =
  let
    currentView = 
      case model of
        LoadingScreen -> View.MidiStatus.view model
        StartScreen -> View.StartScreen.view
        Game gameModel -> View.Game.view gameModel
  in
    div [ ]
        [ 
        View.Header.view model
        , main_ [A.class "gameContainer"] [currentView]
        ]

 

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.handleInitMIDI InitMIDI
        , Ports.handleNotePressed NotePressed
        , Ports.handleNoteReleased NoteReleased
        -- ************************************************
        -- Fake data from fakemidi.js for manual testing:
        -- ************************************************
        , Ports.fakeHandleInitMIDI InitMIDI
        , Ports.fakeHandleNotePressed NotePressed
        , Ports.fakeHandleNoteReleased NoteReleased
        , Browser.Events.onAnimationFrame AnimFrame
        ]



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = Update.update
        , subscriptions = subscriptions
        }


-- Note: Int here is left over from prev version that used session IDs for saving score to local storage....
init : Int -> ( Model, Cmd Msg )
init initialSessionId =
  ( initialModel 
  , Cmd.none 
  )


