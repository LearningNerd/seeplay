module Helpers exposing (..)


-- Convert pixels per frame per frame --> pixels per millisecond per millisecond
convertFramesToMillisAccel accel fps =
  accel * (fps/1000) * (fps/1000)

-- Convert num of frames --> num of milliseconds
convertFramesToMillisDuration durationFrames fps =
  durationFrames * 1000/fps


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

