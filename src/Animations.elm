module Animations exposing (..)


import Constants
import Animation
import Color
import Time
import Dict exposing (Dict)

------------ very temporary solution here =P need to refactor a BUNCH ------------
marioWidthToHeightRatio = 17 / 24 -- 17 px wide, 24 px high

baseSpriteWidth = 17
baseSpriteHeight = 24

----------------------------------------------------------------------


-- initialCurrentNoteStyle : Animation.Messenger.State Msg
initialCurrentNoteStyle = Animation.viewBox 0 0 baseSpriteWidth baseSpriteHeight
                  

marioWalkLoop = spriteLoop 100 baseSpriteWidth baseSpriteHeight 0 2



-- initialCorrectNoteStyle : Animation.Messenger.State Msg
initialCorrectNoteStyle =
  Animation.style [ Animation.opacity 1.0, Animation.fill Color.black ]

initialScrollAnimState = Animation.style [ Animation.viewBox 0 0 Constants.svgViewTotalWidth Constants.svgViewTotalHeight ]

initUniqueAnimStates =
  Dict.fromList [
        (Constants.coinStyle, Animation.style [])
      , (Constants.scrollState, initialScrollAnimState)
      , (Constants.currentNoteStyle, Animation.style [initialCurrentNoteStyle])
      , (Constants.correctNoteStyle, initialCorrectNoteStyle)
      ]

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

