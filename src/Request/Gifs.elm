module Request.Gifs exposing (..)

import Types exposing (..)
import Http exposing (..)
import Json.Decode exposing (list, string, Decoder, at)
import Json.Decode.Pipeline exposing (decode, required, requiredAt)


getGifs : String -> Cmd Msg
getGifs filmName =
    let
        url =
            "https://api.giphy.com/v1/gifs/search?api_key=Pwh6oykW1llZjlVW5hOcjNrytlOiFJDI&q=" ++ toString filmName ++ "&limit=4&offset=0&rating=R&lang=en"

        request =
            Http.get url gifsDecoder
    in
        Http.send UpdateGifUrls request


monoGifDecoder : Decoder ( GifLink, GifSrc )
monoGifDecoder =
    decode (,)
        |> required "url" string
        |> requiredAt [ "images", "fixed_width", "url" ] string


gifsDecoder : Decoder (List ( GifLink, GifSrc ))
gifsDecoder =
    at [ "data" ] (list monoGifDecoder)
