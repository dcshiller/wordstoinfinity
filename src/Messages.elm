module Messages exposing (Msg(..))

import Browser.Dom exposing (Viewport)
import DataTypes exposing (Coords, ServerResponse)


type Msg
    = SelectCoords Coords
    | CharacterKey Char
    | ControlKey String
    | FetchUpdate
    | UpdateState ServerResponse
    | UpdateViewport Viewport
    | SubmitPlacements
    | ClearPlacements
