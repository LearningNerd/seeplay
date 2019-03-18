module UpdateAnimations exposing (update)

import Animation.Messenger
import Msg exposing (..)
import Model exposing (Model)


update : AnimMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      CorrectNoteStyle animMsg ->
        let
            (newStyle, cmd) =
              Animation.Messenger.update animMsg model.correctNoteStyle
        in
            ( { model
                | correctNoteStyle = newStyle
              }
            , cmd -- send any messages triggered by animations
            )

      CurrentNoteStyle animMsg ->
        let
            (newStyle, cmd) =
              Animation.Messenger.update animMsg model.currentNoteStyle
        in
            ( { model
                | currentNoteStyle = newStyle
              }
            , cmd -- send any messages triggered by animations
            )


