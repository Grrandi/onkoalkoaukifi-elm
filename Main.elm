module Main exposing (..)

import App exposing (..)
import Html exposing (program)
import Types exposing (Model, Msg)
import View exposing (view)

-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/http.html
-- http://elmplayground.com/decoding-json-in-elm-1

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL
