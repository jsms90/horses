module Main exposing (..)

import Html exposing (..)
import Types exposing (..)
import Request.Gifs exposing (..)
import Request.Films exposing (..)
import Views.View exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }



-- model


init : ( Model, Cmd Msg )
init =
    ( Model [] [] Nothing Nothing, getFilms )



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateGifUrls (Ok gifUrls) ->
            ( { model | gifUrls = gifUrls }, Cmd.none )

        UpdateGifUrls (Err error) ->
            ( model, Cmd.none )

        UpdateFilms (Ok allFilms) ->
            ( { model | allFilms = allFilms }, Cmd.none )

        UpdateFilms (Err error) ->
            ( model, Cmd.none )

        UpdateSelectedFilm (Ok thisFilm) ->
            ( { model | selectedFilm = Just 1 }, (Request.Gifs.getGifs thisFilm) )

        UpdateSelectedFilm (Err error) ->
            ( model, Cmd.none )

        Hover int ->
            ( { model | hoveredFilm = Just int }, Cmd.none )
