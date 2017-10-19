module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Http exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }



-- model


type alias Model =
    { character : Maybe String
    , gifUrls : List String
    }


model : Model
model =
    { character = Nothing
    , gifUrls = []
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
    | UpdateGifUrls


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectCharacter Totoro ->
            ( { model | character = Just "Totoro" }, Cmd.none )

        SelectCharacter Chibi ->
            ( { model | character = Just "Chibi" }, Cmd.none )

        SelectCharacter NoFace ->
            ( { model | character = Just "NoFace" }, Cmd.none )

        UpdateGifUrls ->
            ( model, Cmd.none )



-- view


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "horseplay" ]
        , createCharacterButton Totoro "http://data.whicdn.com/images/126922727/large.png"
        , createCharacterButton Chibi "https://nialldohertyanimations.files.wordpress.com/2013/04/tumblr_lnco2fx8ln1qfl4meo1_500.png"
        , createCharacterButton NoFace "https://78.media.tumblr.com/7e280aedf900a29345527059dee8631c/tumblr_inline_njc1ezeCV91qg4ggy.png"
        ]


createCharacterButton : Character -> String -> Html Msg
createCharacterButton characterName characterUrl =
    button [ onClick (SelectCharacter characterName), class "pointer grow" ]
        [ img [ src characterUrl, alt <| toString characterName ] []
        ]
