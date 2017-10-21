module Request.Films exposing (..)

import Types exposing (..)
import Http exposing (..)
import Json.Decode exposing (list, string, Decoder)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)


getFilms : Cmd Msg
getFilms =
    let
        url =
            "https://ghibliapi.herokuapp.com/films"

        request =
            Http.get url foundFilmsDecoder
    in
        Http.send UpdateFilms request


foundFilmsDecoder : Decoder (List FilmRecord)
foundFilmsDecoder =
    list filmDecoder


filmDecoder : Decoder FilmRecord
filmDecoder =
    decode FilmRecord
        |> required "title" string
        |> required "description" string
        |> hardcoded []
