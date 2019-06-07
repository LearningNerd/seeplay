module Constants exposing (..)

import Helpers


notesPerLevel = 10

noteXInterval = 200

svgViewWidth = 700
svgViewHeight = 200

staffLineHeight = svgViewHeight / 6

topMargin = 50
bottomMargin = 50
leftMargin = 0
rightMargin = 0

svgViewTotalWidth = svgViewWidth + leftMargin + rightMargin
svgViewTotalHeight = svgViewHeight + topMargin + bottomMargin

-- Player appears here when game is initialized
playerInitialXPosition = 0 -- currently added to leftMargin
playerInitialYPosition = 0

----------------  Animations:

-- Game level view box scrolls by this percent closer to the next target value
-- on each frame.
-- Value between 0 and 1
-- Larger values = faster scrolling (by a lot!)
scrollAnimMultiplier = 0.05

-- To center the player/start of level
scrollOffset = -300

-- Frames per second (just makes the numbers nicer for accel, vel, duration etc)
fps = 60

-- constant velocity for horizontal movement
-- accelXFrames = 0 

-- Increase velocity by 2 pixels per frame per frame
-- positive number means moving downwards for SVG coords
accelYFrames = 2 
accelYMillis = Helpers.convertFramesToMillisAccel accelYFrames fps

-- Complete each jump in x number of frames
jumpDurationFrames = 20
jumpDurationMillis = Helpers.convertFramesToMillisDuration jumpDurationFrames fps

