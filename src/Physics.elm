module Physics exposing (..)


import Model exposing (Vector)
import ConstantsHelpers as Const exposing (accelYMillis, svgViewHeight, shortJumpDurMillis, baseJumpDurMillis, longJumpDurMillis)
import Note


-- Given start pos, target pos, duration, vert acceleration
-- return new velocity for the next jump
updateVelocity : Vector -> Vector -> Float -> Vector
updateVelocity start target dur =
  let
    accel = Vector 0 Const.accelYMillis
    velY = 
      (target.y - start.y - (0.5 * accel.y * dur * dur)) / dur
    velX =
      (target.x - start.x) / dur
  in
    Vector velX velY

-- Given cur pos and target pos ....
-- return new duration for the next jump
updateJumpDur : Vector -> Vector -> Float
updateJumpDur curPos targetPos =
  let
    distanceToJumpY =
      (abs (targetPos.y - curPos.y))

    isJumpVerticalOnly =
      (abs (targetPos.x - curPos.x)) == 0

    minJumpDur =
      if isJumpVerticalOnly then
         Const.shortJumpDurMillis
      else
        -- longer jump for correct notes
        Const.longJumpDurMillis

  in
    minJumpDur
    + Const.baseJumpDurMillis 
    * (distanceToJumpY / Const.svgViewHeight) -- multiplier

    -- OR: do the above math with frames, then use Const.convertFramesToMillisDuration to get millis ???


updateTargetPos midiCode noteIndex =
  let
    newX = Note.getNoteX noteIndex
    newY = Note.getNoteY midiCode
  in
     Vector newX newY


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

