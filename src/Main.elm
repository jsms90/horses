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



-- update
-- view
