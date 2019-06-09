module ConstantsHelpers exposing (..)


import Note exposing (Note)

--------------------------------------------------------------------------------
------------          Constants
--------------------------------------------------------------------------------

notesPerLevel = 10

noteXInterval = 200

svgViewWidth = 700
svgViewHeight = 200

staffLineHeight = svgViewHeight / 6

topMargin = 50
bottomMargin = 50
leftMargin = 200 ---- shifts target notes, not player
rightMargin = 0

svgViewTotalWidth = svgViewWidth + leftMargin + rightMargin
svgViewTotalHeight = svgViewHeight + topMargin + bottomMargin

-- Player appears here when game is initialized
playerInitialXPosition = 0 -- currently added to leftMargin
playerInitialNote = 67 -- controls initial y position; start on G

-------------------------------  Animations: ----------------------------------

-- Game level view box scrolls by this percent closer to the next target value
-- on each frame.
-- Value between 0 and 1
-- Larger values = faster scrolling (by a lot!)
scrollAnimMultiplier = 0.05

-- To center the player/start of level
scrollOffset = -500

-- Frames per second (just makes the numbers nicer for accel, vel, duration etc)
framesPerSecond = 60

-- constant velocity for horizontal movement
-- accelXFrames = 0 

-- Increase velocity by 2 pixels per frame per frame
-- positive number means moving downwards for SVG coords
accelYFrames = 1
-- accelYFrames = 2 
accelYMillis = convertFramesToMillisAccel accelYFrames framesPerSecond

-- Complete each jump in x number of frames
-- jumpDurationFrames = 17
jumpDurationFrames = 35
jumpDurationMillis = convertFramesToMillisDuration jumpDurationFrames framesPerSecond

-- Update sprite animation frame every X milliseconds
spriteAnimDelayFrames = 8
spriteAnimDelayMillis = convertFramesToMillisDuration spriteAnimDelayFrames framesPerSecond


--------------------------------------------------------------------------------
------------          Helpers
--------------------------------------------------------------------------------

-- Convert pixels per frame per frame --> pixels per millisecond per millisecond
convertFramesToMillisAccel accel fps =
  accel * (fps/1000) * (fps/1000)

-- Convert num of frames --> num of milliseconds
convertFramesToMillisDuration durationFrames fps =
  durationFrames * 1000/fps


getNoteXPos noteIndex =
  leftMargin + ((toFloat noteIndex) * (toFloat noteXInterval) )


getNoteYPos midiCode =
  let
    yPosFloat = toFloat (Note.getHeight midiCode)
  in
    topMargin + (yPosFloat * staffLineHeight / 2)


---------  Yay physics! Simple projectile motion (no air resistance etc)  ---------

-- Given start position, target position, vertical acceleration, and total duration,
-- get the required velocity
getRequiredYVelocity startYPos targetYPos accelY durationMillis =
  (targetYPos - startYPos - (0.5 * accelY * durationMillis * durationMillis)) / durationMillis

-- Given target position, start position, and duration (assume acceleration = 0),
-- get the required velocity
getRequiredXVelocity startXPos targetXPos durationMillis =
  (targetXPos - startXPos) / durationMillis

-- Calculate current position given start position, time elapsed, initial velocity, and vertical acceleration
getCurrentJumpYPosition startYPos initialVelocityY accelY elapsedTime =
  (0.5 * accelY * elapsedTime * elapsedTime) + (initialVelocityY * elapsedTime) + startYPos

-- Calculate current position given start position, time elapsed, initial velocity (assuming acceleration = 0)
getCurrentJumpXPosition startXPos initialVelocityX elapsedTime =
  startXPos + (initialVelocityX * elapsedTime)
