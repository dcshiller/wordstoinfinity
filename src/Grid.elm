module Grid exposing (renderGrid)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Messages exposing (..)


renderVerticalLine xCoord =
    div
        [ style "height" "100vh"
        , style "width" "5px"
        , style "background" "black"
        , style "position" "fixed"
        , style "left" (String.fromInt xCoord ++ "in")
        , style "z-index" "1"
        ]
        []


renderHorizontalLine yCoord =
    div
        [ style "width" "100vw"
        , style "height" "5px"
        , style "background" "black"
        , style "position" "fixed"
        , style "top" (String.fromInt yCoord ++ "in")
        , style "z-index" "1"
        ]
        []


verticalLines =
    List.map renderVerticalLine (List.range 0 20)


horizonalLines =
    List.map renderHorizontalLine (List.range 0 20)


renderGrid model =
    div [] <| List.append verticalLines horizonalLines
