module Views.View exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onMouseEnter)


view : Model -> Html Msg
view model =
    div [ class "mh5" ]
        [ h1 [ class "tc f1 hot-pink ma5 b" ] [ text "Studio Ghibli Horseplay" ]
        , createFilmListSection model
        , buildGifs model.gifUrls
        , filmDescriptionTitleFunction model
        ]


createFilmListSection : Model -> Html Msg
createFilmListSection model =
    aside []
        [ ul [] <|
            List.indexedMap createFilmItem model.allFilms
        ]


createFilmItem : Int -> FilmRecord -> Html Msg
createFilmItem index filmRecord =
    li [ class "list white f3 ma1 helvetica", onMouseEnter (Hover index), onClick (UpdateSelectedFilm filmRecord.title) ] [ text filmRecord.title ]


buttonStyle : Attribute msg
buttonStyle =
    class "pointer grow bg-blue h-10 ba b--black br2 ma2"



-- Note, need to turn into createFilmButton
-- createCharacterButton : Character -> String -> Html Msg
-- createCharacterButton characterName characterUrl =
-- -- button [ onClick (SelectCharacter characterName), buttonStyle ]
--     [ img [ src characterUrl, alt <| toString characterName ] []
--     ]


gifStyle : Attribute msg
gifStyle =
    class "grow ma2 br2 h4 flex align-center"


createGif : ( GifLink, GifSrc ) -> Html Msg
createGif ( gifLink, gifSrc ) =
    a [ href gifLink ] [ img [ src gifSrc, alt "a gif", gifStyle ] [] ]


buildGifs : List ( GifLink, GifSrc ) -> Html Msg
buildGifs gifUrls =
    section [ class "bg-pink pa2" ] <| List.map createGif gifUrls



-- [ text (toString (List.length gifUrls)) ]


filmDescriptionTitleFunction : Model -> Html Msg
filmDescriptionTitleFunction model =
    case model.hoveredFilm of
        Nothing ->
            h2 [] [ text "Choose a film, goddamnit" ]

        Just int ->
            h2 [] [ text "wow you choose a film" ]
