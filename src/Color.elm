module Color exposing (green, red, black)


-- Colors to export:

green = rgb 0 255 0

red = rgb 255 20 20

black = rgb 0 0 0


-- Definitions:

type alias Color =
    { red : Int, blue : Int, green : Int, alpha : Float }

rgba r g b a =
    { red = r, blue = b, green = g, alpha = a }

rgb r g b =
    { red = r, blue = b, green = g, alpha = 1 }


