module Main exposing (..)

import Types exposing (..)
import Request.Gifs exposing (..)
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


init : ( Model, Cmd Msg )
init =
    ( Model Nothing [] [], getFilms )



-- update


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

        UpdateFilms (Ok allFilms) ->
            ( { model | allFilms = allFilms }, Cmd.none )

        UpdateFilms (Err error) ->
            ( model, Cmd.none )


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


view : Model -> Html Msg
view model =
    div [ class "flex mh5" ]
        [ h1 [ class "tc f1 pink ma5 b" ] [ text "Studio Ghibli Horseplay" ]
        , div [] [ text <| toString model.allFilms ]
        , titleThing model.character
        , buildGifs model.gifUrls
        , createCharacterButton Totoro "http://data.whicdn.com/images/126922727/large.png"
        , createCharacterButton Chibi "https://nialldohertyanimations.files.wordpress.com/2013/04/tumblr_lnco2fx8ln1qfl4meo1_500.png"
        , createCharacterButton NoFace "https://78.media.tumblr.com/7e280aedf900a29345527059dee8631c/tumblr_inline_njc1ezeCV91qg4ggy.png"
        ]


titleThing : Maybe String -> Html Msg
titleThing selected =
    case selected of
        Just character ->
            h2 [] [ text (character ++ " is very strong") ]

        Nothing ->
            div [] []


buttonStyle : Attribute msg
buttonStyle =
    class "pointer grow bg-blue h-10 ba b--black br2 ma2"


createCharacterButton : Character -> String -> Html Msg
createCharacterButton characterName characterUrl =
    button [ onClick (SelectCharacter characterName), buttonStyle ]
        [ img [ src characterUrl, alt <| toString characterName ] []
        ]


gifStyle : Attribute msg
gifStyle =
    class "grow ma2 br2 h4 flex align-center"


createGif : ( GifLink, GifSrc ) -> Html Msg
createGif ( gifLink, gifSrc ) =
    a [ href gifLink ] [ img [ src gifSrc, alt "a gif", gifStyle ] [] ]


buildGifs : List ( GifLink, GifSrc ) -> Html Msg
buildGifs gifUrls =
    section [ class "bg-pink pa2" ] <| List.map createGif gifUrls
