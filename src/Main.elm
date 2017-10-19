module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Http exposing (..)
import Json.Decode as Json
import Json.Decode.Pipeline exposing (decode, required, requiredAt)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }



-- model


type alias GifLink =
    String


type alias GifSrc =
    String


type alias Model =
    { character : Maybe String
    , gifUrls : List ( GifLink, GifSrc )
    }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing [], Cmd.none )



-- update


type Character
    = Totoro
    | Chibi
    | NoFace


type Msg
    = SelectCharacter Character
    | UpdateGifUrls (Result Http.Error (List ( GifLink, GifSrc )))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectCharacter Totoro ->
            ( { model | character = Just "Totoro" }, getGifs Totoro )

        SelectCharacter Chibi ->
            ( { model | character = Just "Chibi" }, getGifs Chibi )

        SelectCharacter NoFace ->
            ( { model | character = Just "NoFace" }, getGifs NoFace )

        UpdateGifUrls (Ok gifUrls) ->
            ( { model | gifUrls = gifUrls }, Cmd.none )

        UpdateGifUrls (Err error) ->
            ( model, Cmd.none )


getGifs : Character -> Cmd Msg
getGifs characterName =
    let
        url =
            "https://api.giphy.com/v1/gifs/search?api_key=Pwh6oykW1llZjlVW5hOcjNrytlOiFJDI&q=" ++ toString characterName ++ "&limit=8&offset=0&rating=R&lang=en"

        request =
            Http.get url gifsDecoder
    in
        Http.send UpdateGifUrls request


monoGifDecoder : Json.Decoder ( GifLink, GifSrc )
monoGifDecoder =
    decode (,)
        |> Json.Decode.Pipeline.required "url" Json.string
        |> requiredAt [ "images", "fixed_width", "url" ] Json.string


gifsDecoder : Json.Decoder (List ( GifLink, GifSrc ))
gifsDecoder =
    Json.at [ "data" ] (Json.list monoGifDecoder)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "horseplay" ]
        , buildGifs model.gifUrls
        , createCharacterButton Totoro "http://data.whicdn.com/images/126922727/large.png"
        , createCharacterButton Chibi "https://nialldohertyanimations.files.wordpress.com/2013/04/tumblr_lnco2fx8ln1qfl4meo1_500.png"
        , createCharacterButton NoFace "https://78.media.tumblr.com/7e280aedf900a29345527059dee8631c/tumblr_inline_njc1ezeCV91qg4ggy.png"
        ]


createCharacterButton : Character -> String -> Html Msg
createCharacterButton characterName characterUrl =
    button [ onClick (SelectCharacter characterName), class "pointer grow" ]
        [ img [ src characterUrl, alt <| toString characterName ] []
        ]


createGif : ( GifLink, GifSrc ) -> Html Msg
createGif ( gifLink, gifSrc ) =
    a [ href gifLink ] [ img [ src gifSrc, alt "a gif" ] [] ]


buildGifs : List ( GifLink, GifSrc ) -> Html Msg
buildGifs gifUrls =
    section [] <| List.map createGif gifUrls
