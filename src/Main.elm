module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Events exposing (onKeyDown)
import DataTypes exposing (Coords, Model, Space)
import Debug
import Grid exposing (renderGrid)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (field, int, list, map3, string)
import Messages exposing (..)
import Platform.Cmd exposing (batch)
import PlayerPanel exposing (renderPanel)
import Server
import Space exposing (renderSpace)
import Task


initViewport =
    { scene =
        { width = 0.0
        , height = 0.0
        }
    , viewport =
        { x = 0.0
        , y = 0.0
        , width = 0.0
        , height = 0.0
        }
    }


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init flags =
    ( { grid = []
      , letters = [ 'a', 'b', 'c', 'd', 'e', 'f', 'g' ]
      , enteredLetters = []
      , selectedCoords = { x = 0, y = 0 }
      , viewport = initViewport
      , offset = { x = 0, y = 0 }
      }
    , batch
        [ Server.getState
        , Task.perform UpdateViewport Browser.Dom.getViewport
        ]
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
            ( model, Server.getState )

        UpdateState result ->
            case result of
                Ok text ->
                    ( { model | grid = Server.extractState text }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        UpdateViewport viewport ->
            ( { model | viewport = viewport }, Cmd.none )

        SubmitPlacements ->
            ( { model | enteredLetters = [] }, Server.postPlacements model )

        ClearPlacements ->
            ( { model | enteredLetters = [] }, Cmd.none )


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

        newX =
            currentSelectedCoords.x + xChange

        newY =
            currentSelectedCoords.y + yChange
    in
    { model
        | selectedCoords =
            { currentSelectedCoords
                | x = newX
                , y = newY
            }
        , offset =
            { x = max (min model.offset.x newX) (newX - 10)
            , y = max (min model.offset.y newY) (newY - 10)
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
    list |> List.map (\x -> renderSpace x model.offset (sameCoords model.selectedCoords x) SelectCoords)


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
        , renderGrid model
        , renderPanel model
        ]
