module Animations exposing (..)

import Msg exposing (..)
import Constants
import Animation
import Animation.Messenger
import Color
import Time
import Dict exposing (Dict)


----- refactor this!!! =P
baseSpriteWidth = 17
baseSpriteHeight = 24


coinDisappear =
  [ Animation.toWith 
        (Animation.easing
            { duration = 300
            , ease = (\x -> x^2)
            }
        ) 
    [ Animation.opacity 0 ]

  , Animation.Messenger.send GetCoinDone
  ]

-- initialCorrectNoteStyle : Animation.Messenger.State Msg
initialCorrectNoteStyle =
  Animation.style [ Animation.opacity 1.0, Animation.fill Color.black ]


    -- calculate all future x positions in View/Mario/getMarioXPosition!
-- initialCurrentNoteStyle : Animation.Messenger.State Msg
initialCurrentNoteStyle = [ Animation.viewBox 0 0 baseSpriteWidth baseSpriteHeight ]

-- outer SVG for Mario's x / y position!
initialMarioContainerStyle = [ Animation.x (Constants.leftMargin) ]



initialScrollAnimState = Animation.style [ Animation.viewBox 0 0 Constants.svgViewTotalWidth Constants.svgViewTotalHeight ]


initUniqueAnimStates =
  Dict.fromList [
        (Constants.coinStyle, Animation.style [])
      , (Constants.scrollState, initialScrollAnimState)
      , (Constants.currentNoteStyle, Animation.style initialCurrentNoteStyle)
      , (Constants.marioContainer, Animation.style initialMarioContainerStyle)
      , (Constants.correctNoteStyle, initialCorrectNoteStyle)
      ]


-- individual sprite, static
staticSprite spriteWidth spriteHeight spriteIndex =
  Animation.set [Animation.viewBox ((spriteWidth * spriteIndex)) 0.0 (spriteWidth) (spriteHeight)]


-- spriteLoop : Int -> Int -> Int -> Int -> Animation.Model.Step msg
spriteLoop delayMillis spriteWidth spriteHeight firstSpriteIndex numSprites =
  let
      loopForwardHalf = 
        List.concatMap (\i ->
          [Animation.set [Animation.viewBox ((spriteWidth * i)) 0.0 (spriteWidth) (spriteHeight)]
          , Animation.wait (Time.millisToPosix delayMillis)
          ]
        ) (List.map toFloat <| List.range firstSpriteIndex (numSprites - 1))
      -- loopBackwardHalf = List.reverse loopForwardHalf |> List.drop 2 -- don't repeat last sprite twice
  in
    -- Animation.loop (loopForwardHalf ++ loopBackwardHalf)
    [ Animation.loop loopForwardHalf ]

coinLoop = spriteLoop 100 16 16 0 4
-- **** store the above, and starting locations of each sprite also???


scrollAndWalkEasing =
        (Animation.spring
            { stiffness = 50
            , damping = 50
            }
        ) 
{--
                    (Animation.easing
                      { duration = 2000
                      , ease = (\x -> x^2)
                      }
                  )
--}


-- scrollGameLevel : Int -> Animation.Step
scrollGameLevel nextNoteIndex =
  let
      nextViewBoxStartPos = ((toFloat nextNoteIndex) * Constants.noteXInterval)
      test = Debug.log "next xPos: " nextViewBoxStartPos
  in
    Animation.toWith scrollAndWalkEasing

       [ Animation.viewBox nextViewBoxStartPos 0 Constants.svgViewTotalWidth Constants.svgViewTotalHeight ]

