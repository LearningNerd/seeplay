module View.TestSprite exposing (view)

import Animation
import Animation.Messenger
import Model exposing (Model, Margins)
import Msg exposing (..)
import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as S exposing (..)


view : Model -> Html Msg
view model =
  div [] [ 
    svg [ S.width "500"
        , S.height "500"
        , S.viewBox ("0 0 500 500")
        , S.class "center"
        ]
        [ (circleSpriteSvg 200 100 model)
        --, use [x "50", y "50", xlinkHref "#mario" ] []
        --, image [src "https://www.mariowiki.com/images/archive/a/ad/20180127224241%21MBNESMarioSprite.gif"] []
        -- , (coinSprite)
        
        ]
    ]

-- circleSpriteSvg xPos yPos spriteNum model =
circleSpriteSvg xPos yPos model =
    let
        spriteWidth = 50
        spriteHeight = 50
        -- viewBoxStartX = (spriteNum - 1) * spriteWidth
        -- viewBoxEndX = viewBoxStartX + spriteWidth
        
    in
      svg 
        (Animation.render model.spriteStyle ++ -- control viewbox programmatically!
        [S.x (String.fromInt xPos)
        , S.y (String.fromInt yPos)
        , S.width (String.fromInt spriteWidth)
        , S.height (String.fromInt spriteHeight)
        {--
        , S.viewBox ( String.fromInt viewBoxStartX ++ " 0 "
                        ++ String.fromInt spriteWidth ++ " "
                        ++ String.fromInt spriteHeight
                     )
         --}
        ]
        ) <| List.map drawCircle [("red", 0), ("blue", 1), ("green", 2)]

drawCircle (color, pos) =
    circle
       [ S.cx <| String.fromInt (pos * 50 + 25)
        , S.cy "25"
        , S.r "25"
        , fill color
        ]
        []


