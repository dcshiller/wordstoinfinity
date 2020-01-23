module Main exposing (main)

import Browser
import Browser.Events exposing (onKeyDown)
import Debug
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (field, int, list, map3, string)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type Msg
    = SelectCoords Coords
    | CharacterKey Char
    | ControlKey String
    | FetchUpdate
    | UpdateState (Result Http.Error (List Placement))


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
    }


init flags =
    ( { grid = []
      , letters = [ 'a', 'b', 'c', 'd', 'e', 'f', 'g' ]
      , enteredLetters = []
      , selectedCoords = { x = 0, y = 0 }
      }
    , getState
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    onKeyDown keyDecoder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectCoords space ->
            ( { model | selectedCoords = space }, Cmd.none )

        CharacterKey char ->
            ( updateEnteredLetters model char, Cmd.none )

        ControlKey string ->
            ( updateSelection model string, Cmd.none )

        FetchUpdate ->
            ( model, getState )

        UpdateState result ->
            case result of
                Ok text ->
                    ( { model | grid = placementsToSpaces text }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


keyDecoder : Decode.Decoder Msg
keyDecoder =
    Decode.map toKey (Decode.field "key" Decode.string)


toKey : String -> Msg
toKey keyValue =
    case String.uncons keyValue of
        Just ( char, "" ) ->
            CharacterKey char

        _ ->
            ControlKey keyValue


log model result =
    let
        x =
            Debug.log "y" (Debug.toString result)
    in
    model


firstChar list =
    case List.head list of
        Just char ->
            char

        _ ->
            ' '


placementToSpace placement =
    { x = placement.x
    , y = placement.y
    , letter =
        firstChar (String.toList placement.value)
    }


placementsToSpaces placements =
    List.map placementToSpace placements


placementDecoder =
    field "placements" <| list (map3 Placement (field "x" int) (field "y" int) (field "value" string))


getState =
    Http.get
        { url = "http://localhost:3000/state"
        , expect = Http.expectJson UpdateState placementDecoder
        }


updateEnteredLetters model char =
    let
        currentEnteredLetters =
            model.enteredLetters

        selectedCoords =
            model.selectedCoords

        newEnteredLetter =
            { letter = char, x = selectedCoords.x, y = selectedCoords.y }
    in
    { model | enteredLetters = newEnteredLetter :: currentEnteredLetters }


arrowKeyCodeToChange string =
    case string of
        "ArrowLeft" ->
            ( -1, 0 )

        "ArrowRight" ->
            ( 1, 0 )

        "ArrowUp" ->
            ( 0, -1 )

        "ArrowDown" ->
            ( 0, 1 )

        _ ->
            ( 0, 0 )


updateSelection model string =
    let
        ( xChange, yChange ) =
            arrowKeyCodeToChange string

        currentSelectedCoords =
            model.selectedCoords
    in
    { model
        | selectedCoords =
            { currentSelectedCoords
                | x = currentSelectedCoords.x + xChange
                , y = currentSelectedCoords.y + yChange
            }
    }


coordsToSpace numX numY =
    { x = numX, y = numY, letter = ' ' }


emptyGrid model =
    let
        range =
            List.range 0 15
    in
    List.concatMap (\x -> List.map (coordsToSpace x) range) range


coalesceSpace : Space -> Space -> Space
coalesceSpace coord2 coord1 =
    if coord1.x == coord2.x && coord1.y == coord2.y && coord2.letter /= ' ' then
        coord2

    else
        coord1


coalesceSpaceFromList : List Space -> Space -> Space
coalesceSpaceFromList grid coord =
    List.foldl coalesceSpace coord grid


mergeSpaceLists : List Space -> List Space -> List Space
mergeSpaceLists grid1 grid2 =
    List.map (coalesceSpaceFromList grid2) grid1


renderSpace space selected =
    let
        color =
            (\x ->
                if x then
                    "red"

                else
                    "black"
            )
                selected

        zIndex =
            (\x ->
                if x then
                    "2"

                else
                    "1"
            )
                selected
    in
    div
        [ style "position" "absolute"
        , style "top" (String.fromInt space.y ++ "in")
        , style "left" (String.fromInt space.x ++ "in")
        , style "width" "1in"
        , style "height" "1in"
        , style "border" ("3px solid " ++ color)
        , style "font-size" "1in"
        , style "box-sizing" "border-box"
        , style "text-align" "1center"
        , style "display" "flex"
        , style "align-items" "center"
        , style "justify-content" "space-around"
        , style "z-index" zIndex
        , onClick (SelectCoords { x = space.x, y = space.y })
        ]
        [ text <| String.fromChar space.letter
        ]


sameCoords coords space =
    coords.x == space.x && coords.y == space.y


displayedSpaces : Model -> List (Html Msg)
displayedSpaces model =
    let
        list =
            mergeSpaceLists
                (mergeSpaceLists (emptyGrid model) model.grid)
                (mergeSpaceLists (emptyGrid model) model.enteredLetters)
    in
    list |> List.map (\x -> renderSpace x (sameCoords model.selectedCoords x))


view model =
    div
        [ style "position" "fixed"
        , style "top" "0in"
        , style "left" "0in"
        ]
        [ div
            [ style "position" "relative"
            , style "top" "0"
            , style "left" "0"
            ]
            (displayedSpaces model)
        ]
