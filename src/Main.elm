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


type alias PeopleUrl =
    String


type alias FilmRecord =
    { title : String
    , description : String
    , peopleList : List PeopleUrl
    , filmUrl : String
    }


type alias Model =
    { character : Maybe String
    , gifUrls : List ( GifLink, GifSrc )
    , allFilms : List FilmRecord
    }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing [] [], Cmd.none )



-- update


type Character
    = Totoro
    | Chibi
    | NoFace


type Msg
    = SelectCharacter Character
    | UpdateGifUrls (Result Http.Error (List ( GifLink, GifSrc )))
    | UpdateFilms (Result Http.Error (List FilmRecord))


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


getGifs : Character -> Cmd Msg
getGifs characterName =
    let
        url =
            "https://api.giphy.com/v1/gifs/search?api_key=Pwh6oykW1llZjlVW5hOcjNrytlOiFJDI&q=" ++ toString characterName ++ "&limit=8&offset=0&rating=R&lang=en"

        request =
            Http.get url gifsDecoder
    in
        Http.send UpdateGifUrls request


getFilms : Cmd Msg
getFilms =
    let
        url =
            "https://ghibliapi.herokuapp.com/films"

        request =
            Http.get url foundFilmsDecoder
    in
        Http.send UpdateFilms request


monoGifDecoder : Json.Decoder ( GifLink, GifSrc )
monoGifDecoder =
    decode (,)
        |> Json.Decode.Pipeline.required "url" Json.string
        |> requiredAt [ "images", "fixed_width", "url" ] Json.string


gifsDecoder : Json.Decoder (List ( GifLink, GifSrc ))
gifsDecoder =
    Json.at [ "data" ] (Json.list monoGifDecoder)


foundFilmsDecoder : Json.Decoder (List FilmRecord)
foundFilmsDecoder =
    Json.list filmDecoder


filmDecoder : Json.Decoder FilmRecord
filmDecoder =
    decode FilmRecord
        |> Json.Decode.Pipeline.required "title" Json.string
        |> Json.Decode.Pipeline.required "description" Json.string
        |> Json.Decode.Pipeline.required "people" (Json.list Json.string)
        |> Json.Decode.Pipeline.required "url" Json.string


containsPeople : FilmRecord -> Bool
containsPeople film =
    List.length film.peopleList > 1


view : Model -> Html Msg
view model =
    div [ class "flex mh5" ]
        [ h1 [ class "tc f1 pink ma5 b" ] [ text "Studio Ghibli Horseplay" ]
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
