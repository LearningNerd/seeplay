module ConstantsHelpers exposing (..)


import Note exposing (Note)

--------------------------------------------------------------------------------
------------          Constants
--------------------------------------------------------------------------------

notesPerLevel = 100

noteXInterval = 300

svgViewWidth = 1400
svgViewHeight = 400

staffLineHeight = svgViewHeight / 6

topMargin = 50
bottomMargin = 50
leftMargin = 300 ---- shifts target notes, not player
rightMargin = 0

trebleLeftMargin = 20

svgViewTotalWidth = svgViewWidth + leftMargin + rightMargin
svgViewTotalHeight = svgViewHeight + topMargin + bottomMargin

-- Player appears here when game is initialized
playerInitialXPosition = 0 -- currently added to leftMargin
playerInitialNote = 67 -- controls initial y position; start on G

-- To center the player/start of level
scrollOffset = -900


correctTargetSpriteImage = "img/happycloud-59w-44h-5i.png"
nextTargetSpriteImage = "img/raincloud-59w-44h-5i.png"

-------------------------------  Animations: ----------------------------------

-- Game level view box scrolls by this percent closer to the next target value
-- on each frame.
-- Value between 0 and 1
-- Larger values = faster scrolling (by a lot!)
scrollAnimMultiplier = 0.05

-- Frames per second (just makes the numbers nicer for accel, vel, duration etc)
framesPerSecond = 60

-- constant velocity for horizontal movement
-- accelXFrames = 0 

-- Increase velocity by 2 pixels per frame per frame
-- positive number means moving downwards for SVG coords
accelYFrames = 0.6
-- accelYFrames = 2 
accelYMillis = convertFramesToMillisAccel accelYFrames framesPerSecond

-- Complete each jump in x number of frames
longJumpDurationFrames = 35

-- Even the smallest jump takes at least this many frames:
shortJumpDurationFrames = 15 

-- The largest jump is minJumpDurationFrames plus this many frames, or as a percentage of total staff height:
baseJumpDurationFrames = 20


longJumpDurMillis = 
  convertFramesToMillisDuration longJumpDurationFrames framesPerSecond

shortJumpDurMillis = 
  convertFramesToMillisDuration shortJumpDurationFrames framesPerSecond

baseJumpDurMillis = 
  convertFramesToMillisDuration baseJumpDurationFrames framesPerSecond


-- Update sprite animation frame every X milliseconds
spriteAnimDelayFrames = 8
spriteAnimDelayMillis = round <| convertFramesToMillisDuration spriteAnimDelayFrames framesPerSecond


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

