module Request.Films exposing (..)

import Types exposing (..)
import Http exposing (..)
import Json.Decode as Json
import Json.Decode.Pipeline exposing (decode, required)


getFilms : Cmd Msg
getFilms =
    let
        url =
            "https://ghibliapi.herokuapp.com/films"

        request =
            Http.get url foundFilmsDecoder
    in
        Http.send UpdateFilms request


foundFilmsDecoder : Json.Decoder (List FilmRecord)
foundFilmsDecoder =
    Json.list filmDecoder


filmDecoder : Json.Decoder FilmRecord
filmDecoder =
    decode FilmRecord
        |> Json.Decode.Pipeline.required "title" Json.string
        |> Json.Decode.Pipeline.required "description" Json.string
