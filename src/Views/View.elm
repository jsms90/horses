module Views.View exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)


view : Model -> Html Msg
view model =
    div [ class "flex mh5" ]
        [ h1 [ class "tc f1 pink ma5 b" ] [ text "Studio Ghibli Horseplay" ]
        , div [] [ text <| toString model.allFilms ]
        , buildGifs model.gifUrls
        ]


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
