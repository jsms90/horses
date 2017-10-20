module Types exposing (..)

import Http exposing (..)


type Character
    = Totoro
    | Chibi
    | NoFace


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
    { character : Maybe String
    , gifUrls : List ( GifLink, GifSrc )
    , allFilms : List FilmRecord
    }


type Msg
    = SelectCharacter Character
    | UpdateGifUrls (Result Http.Error (List ( GifLink, GifSrc )))
    | UpdateFilms (Result Http.Error (List FilmRecord))
