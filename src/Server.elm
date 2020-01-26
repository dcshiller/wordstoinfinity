module Server exposing (extractState, getState, postPlacements)

import DataTypes exposing (Placement)
import Http
import Json.Decode as Decode exposing (field, int, list, map3, string)
import Json.Encode as Encode
import Messages exposing (..)


firstChar list =
    case List.head list of
        Just char ->
            char

        _ ->
            ' '


encodePlacement placement =
    Encode.object
        [ ( "x", Encode.int placement.x )
        , ( "y", Encode.int placement.y )
        , ( "value", Encode.string <| String.fromChar placement.letter )
        ]


encodePlacements placements =
    Encode.object
        [ ( "placements", Encode.list encodePlacement placements )
        ]


postPlacements model =
    let
        placements =
            model.enteredLetters
    in
    Http.post
        { url = "http://localhost:3000/move"
        , body = Http.jsonBody (encodePlacements placements)
        , expect = Http.expectJson UpdateState placementDecoder
        }


getState =
    Http.get
        { url = "http://localhost:3000/state"
        , expect = Http.expectJson UpdateState placementDecoder
        }


placementToSpace placement =
    { x = placement.x
    , y = placement.y
    , letter =
        firstChar (String.toList placement.value)
    }


extractState placements =
    List.map placementToSpace placements


placementDecoder =
    field "placements" <| list (map3 Placement (field "x" int) (field "y" int) (field "value" string))
