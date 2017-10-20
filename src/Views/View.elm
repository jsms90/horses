module Views.View exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onMouseEnter, onMouseLeave)
import List.Extra exposing (getAt)


view : Model -> Html Msg
view model =
    div [ class "mh5" ]
        [ h1 [ class "tc f-headline gold pb4 bb b--gold bw3" ] [ text "Studio Ghibli Horseplay" ]
        , p [ class "white f2 ml4 mb1" ] [ text "Studio Ghibli films" ]
        , div [ class "flex" ]
            [ createFilmListSection model
            , filmDescription model
            ]
        , buildGifs model.gifUrls
        ]


createFilmListSection : Model -> Html Msg
createFilmListSection model =
    aside [ class "flex w-40" ]
        [ ul [] <|
            List.indexedMap createFilmItem model.allFilms
        ]


createFilmItem : Int -> FilmRecord -> Html Msg
createFilmItem index filmRecord =
    li
        [ class "list white f3 ma1 helvetica pointer"
        , onMouseEnter
            (Hover
                index
            )
        , onMouseLeave Unhover
        , onClick (UpdateSelectedFilm filmRecord.title)
        ]
        [ text filmRecord.title ]


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
            h2 [ class "flex white w-60 helvetica i fw2 lh-copy mr5" ] [ text "Hover over a film title to see the description! Click for gifs!" ]

        Just int ->
            let
                description =
                    case getAt int model.allFilms of
                        Nothing ->
                            "You broke it."

                        Just film ->
                            film.description
            in
                h2 [ class "flex white w-60 helvetica i fw2 lh-copy mr5" ] [ text description ]
