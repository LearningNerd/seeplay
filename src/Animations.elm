module Animations exposing (..)

import Constants
import Animation
import Color
import Time
import Dict exposing (Dict)

-- initialCurrentNoteStyle : Animation.Messenger.State Msg
initialCurrentNoteStyle =
  Animation.style [ Animation.opacity 0.0, Animation.fill Color.red ]

-- initialCorrectNoteStyle : Animation.Messenger.State Msg
initialCorrectNoteStyle =
  Animation.style [ Animation.opacity 1.0, Animation.fill Color.black ]

initialScrollAnimState = Animation.style [ Animation.viewBox 0 0 Constants.svgViewTotalWidth Constants.svgViewTotalHeight ]

initUniqueAnimStates =
  Dict.fromList [
        (Constants.coinStyle, Animation.style [])
      , (Constants.scrollState, initialScrollAnimState)
      , (Constants.currentNoteStyle, initialCurrentNoteStyle)
      , (Constants.correctNoteStyle, initialCorrectNoteStyle)
      ]

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

-- scrollGameLevel : Int -> Animation.Step
scrollGameLevel nextNoteIndex =
  let
      nextViewBoxStartPos = ((toFloat nextNoteIndex) * Constants.noteXInterval)
      test = Debug.log "next xPos: " nextViewBoxStartPos
  in
    Animation.toWith
{--
        (Animation.easing
            { duration = 2000
            , ease = (\x -> x^2)
            }
        ) 
--}
        (Animation.spring
            { stiffness = 100
            , damping = 50
            }
        ) 
        [ Animation.viewBox nextViewBoxStartPos 0 Constants.svgViewTotalWidth Constants.svgViewTotalHeight ]

