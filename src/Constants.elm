module Constants exposing (..)

notesPerLevel = 10

noteXInterval = 200

svgViewWidth = 700
svgViewHeight = 200

staffLineHeight = svgViewHeight / 6

topMargin = 50
bottomMargin = 50
leftMargin = 50
rightMargin = 0

svgViewTotalWidth = svgViewWidth + leftMargin + rightMargin
svgViewTotalHeight = svgViewHeight + topMargin + bottomMargin

-- ---------- Constants for animated elem states --------------
coinStyle = "coinStyle"
scrollState = "gameLevelScrollState"
currentNoteStyle = "currentNoteStyle" -- Mario sprite style
marioContainer = "marioContainer" -- Mario sprite style
correctNoteStyle = "correctNoteStyle"


