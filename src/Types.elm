module Types exposing (..)

import Http exposing (..)


type alias GifLink =
    String


type alias GifSrc =
    String


type alias PeopleUrl =
    String


type alias FilmRecord =
    { title : String
    , description : String
    }


type alias Model =
    { gifUrls : List ( GifLink, GifSrc )
    , allFilms : List FilmRecord
    , hoveredFilm : Maybe Int
    , selectedFilm : Maybe Int
    }


type Msg
    = UpdateGifUrls (Result Http.Error (List ( GifLink, GifSrc )))
    | UpdateFilms (Result Http.Error (List FilmRecord))
    | UpdateSelectedFilm String
    | Hover Int
    | Unhover
