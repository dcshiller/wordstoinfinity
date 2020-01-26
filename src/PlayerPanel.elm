module PlayerPanel exposing (renderPanel)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Messages exposing (..)


renderPanel model =
    div
        [ style "width" "100%"
        , style "height" "10em"
        , style "z-index" "3"
        , style "position" "fixed"
        , style "bottom" "0"
        , style "background" "pink"
        ]
        [ button
            [ onClick Messages.SubmitPlacements ]
            [ text "submit" ]
        , button
            [ onClick Messages.ClearPlacements ]
            [ text "clear" ]
        ]
