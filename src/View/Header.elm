module View.Header exposing (view)

import Model exposing (Model)
import Msg exposing (..)
import Html as HTML exposing (..)
import Html.Attributes as A exposing (..)

view : Model -> Html Msg
view model = 
    header [] [ 
      div [A.class "container"] [
        h1 [] [ HTML.text "SeePlay" ]
              , p [] [ HTML.text "Learn to sight-read sheet music! SeePlay teaches you to hear with your eyes and play from your heart. 👀🎹💖"]
      ] -- end div.container
    ] -- end header

