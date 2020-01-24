module Space exposing (renderSpace)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


color selected =
    if selected then
        "red"

    else
        "black"


backgroundColor space =
    if space.letter /= ' ' then
        "tan"

    else
        "white"


zIndex selected =
    if selected then
        "2"

    else
        "1"


renderLetter space =
    case space.letter of
        ' ' ->
            div [] []

        _ ->
            div
                [ style "background" (backgroundColor space)
                , style "height" "80%"
                , style "width" "80%"
                , style "display" "flex"
                , style "align-items" "center"
                , style "justify-content" "space-around"
                , style "box-shadow" "2px 2px 2px black"
                , style "border" "2px solid #a5742abf"
                , style "transform" "rotate 2deg"
                ]
                [ text <| String.fromChar space.letter ]


renderSpace space selected msg =
    div
        [ style "position" "absolute"
        , style "top" (String.fromInt space.y ++ "in")
        , style "left" (String.fromInt space.x ++ "in")
        , style "width" "1in"
        , style "height" "1in"
        , style "border" ("3px solid " ++ color selected)
        , style "font-size" "1in"
        , style "box-sizing" "border-box"
        , style "display" "flex"
        , style "align-items" "center"
        , style "justify-content" "space-around"
        , style "text-align" "1center"
        , style "z-index" (zIndex selected)
        , onClick (msg { x = space.x, y = space.y })
        ]
        [ renderLetter space ]
