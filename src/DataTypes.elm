module DataTypes exposing (Coords, Model, Placement, ServerResponse, Space)

import Browser.Dom exposing (Viewport)
import Http


type alias Coords =
    { x : Int
    , y : Int
    }


type alias Placement =
    { x : Int
    , y : Int
    , value : String
    }


type alias Space =
    { x : Int
    , y : Int
    , letter : Char
    }


type alias Model =
    { grid : List Space
    , letters : List Char
    , enteredLetters : List Space
    , selectedCoords : Coords
    , viewport : Viewport
    , offset : Coords
    }


type alias ServerResponse =
    Result Http.Error (List Placement)
