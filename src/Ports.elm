port module Ports exposing (..)

import Json.Encode as E


port handleInitMIDI : (Bool -> msg) -> Sub msg
port handleNotePressed : (Int -> msg) -> Sub msg
port handleNoteReleased : (Bool -> msg) -> Sub msg

port saveLocalData : E.Value -> Cmd msg

-- Fake data from fakemidi.js (manual testing in browser)
port fakeHandleInitMIDI : (Bool -> msg) -> Sub msg
port fakeHandleNotePressed : (Int -> msg) -> Sub msg
port fakeHandleNoteReleased : (Bool -> msg) -> Sub msg

