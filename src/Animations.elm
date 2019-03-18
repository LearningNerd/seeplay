module Animations exposing (..)

import Animation
import Color

-- initialCurrentNoteStyle : Animation.Messenger.State Msg
initialCurrentNoteStyle =
  Animation.style [ Animation.opacity 0.0, Animation.fill Color.red ]

-- initialCorrectNoteStyle : Animation.Messenger.State Msg
initialCorrectNoteStyle =
  Animation.style [ Animation.opacity 1.0, Animation.fill Color.black ]


