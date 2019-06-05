module Constants exposing (..)

notesPerLevel = 10

noteXInterval = 200

svgViewWidth = 700
svgViewHeight = 200

staffLineHeight = svgViewHeight / 6

topMargin = 50
bottomMargin = 50
leftMargin = 100
rightMargin = 0

svgViewTotalWidth = svgViewWidth + leftMargin + rightMargin
svgViewTotalHeight = svgViewHeight + topMargin + bottomMargin

----------------  Animations:

-- Game level view box scrolls by this percent closer to the next target value
-- on each frame.
-- Value between 0 and 1
-- Larger values = faster scrolling (by a lot!)
scrollAnimMultiplier = 0.05

-- To center the player/start of level
scrollOffset = -150

