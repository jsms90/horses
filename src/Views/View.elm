module Views.View exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onMouseEnter)
import List.Extra exposing (getAt)


view : Model -> Html Msg
view model =
    div [ class "mh5" ]
        [ h1 [ class "tc f1 orange ma5 b" ] [ text "Studio Ghibli Horseplay" ]
        , createFilmListSection model
        , buildGifs model.gifUrls
        , filmDescription model
        ]


createFilmListSection : Model -> Html Msg
createFilmListSection model =
    aside []
        [ ul [] <|
            List.indexedMap createFilmItem model.allFilms
        ]


createFilmItem : Int -> FilmRecord -> Html Msg
createFilmItem index filmRecord =
    li [ class "list white f3 ma1 helvetica", onMouseEnter (Hover index) ] [ text filmRecord.title ]


buttonStyle : Attribute msg
buttonStyle =
    class "pointer grow bg-blue h-10 ba b--black br2 ma2"


gifStyle : Attribute msg
gifStyle =
    class "grow ma2 br2 h4 flex align-center"


createGif : ( GifLink, GifSrc ) -> Html Msg
createGif ( gifLink, gifSrc ) =
    a [ href gifLink ] [ img [ src gifSrc, alt "a gif", gifStyle ] [] ]


buildGifs : List ( GifLink, GifSrc ) -> Html Msg
buildGifs gifUrls =
    section [ class "bg-pink pa2" ] <| List.map createGif gifUrls


filmDescription : Model -> Html Msg
filmDescription model =
    case model.hoveredFilm of
        Nothing ->
            h2 [] [ text "Choose a film, goddamnit" ]

        Just int ->
            let
                description =
                    case getAt int model.allFilms of
                        Nothing ->
                            "you broke it"

                        Just film ->
                            film.description
            in
                h2 [] [ text description ]
