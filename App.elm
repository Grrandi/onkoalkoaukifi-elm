module App exposing (..)

import Types exposing (..)
import HttpStuff exposing (getOpenAlkos, getOpenAlkoInfo)

init : (Model, Cmd Msg)
init =
  ( Model 0 0 Nothing Nothing
  , Cmd.batch [getOpenAlkos, getOpenAlkoInfo]
  )

-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotCount (Ok res) ->
      (Model res.open res.closed Nothing model.openStores, Cmd.none)
    GotCount (Err er) ->
      (model, Cmd.none)

    GotInfo result ->
      case result of
        Ok stores ->
          ({model | openStores = Just stores}, Cmd.none)
        Err e ->
          ({model | error = Just e}, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
