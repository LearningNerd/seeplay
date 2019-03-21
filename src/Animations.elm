module Animations exposing (..)

import Animation
import Color
import Time

-- initialCurrentNoteStyle : Animation.Messenger.State Msg
initialCurrentNoteStyle =
  Animation.style [ Animation.opacity 0.0, Animation.fill Color.red ]

-- initialCorrectNoteStyle : Animation.Messenger.State Msg
initialCorrectNoteStyle =
  Animation.style [ Animation.opacity 1.0, Animation.fill Color.black ]

-- spriteLoop : Int -> Int -> Int -> Int -> Animation.Model.Step msg
spriteLoop delayMillis spriteWidth spriteHeight numSprites =
  let
      loopForwardHalf = 
        List.concatMap (\i ->
          [Animation.set [Animation.viewBox (toFloat (spriteWidth * i)) 0.0 (toFloat spriteWidth) (toFloat spriteHeight)]
          , Animation.wait (Time.millisToPosix delayMillis)
          ]
        ) (List.range 0 (numSprites - 1))
      -- loopBackwardHalf = List.reverse loopForwardHalf |> List.drop 2 -- don't repeat last sprite twice
  in
    -- Animation.loop (loopForwardHalf ++ loopBackwardHalf)
    Animation.loop loopForwardHalf

coinLoop = spriteLoop 100 16 16 4
-- **** store the above, and starting locations of each sprite also???

