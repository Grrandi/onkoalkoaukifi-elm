module App exposing (..)

import Types exposing (..)
import HttpStuff exposing (getOpenAlkos, getOpenAlkoInfo)
import Task
import Geolocation

init : (Model, Cmd Msg)
init =
  ( Model 0 0 Nothing Nothing (Ok Nothing)
  , Cmd.batch [getOpenAlkos, getOpenAlkoInfo, Task.attempt GotGeoloc Geolocation.now]
  )

-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotCount result ->
      case result of
        Ok res ->
          ({model | openCount = res.open, totalCount = res.closed}, Cmd.none)
--          (Model res.open res.closed Nothing model.openStores, Cmd.none)
        Err e ->
          ({model | error = Just e}, Cmd.none)

    GotInfo result ->
      case result of
        Ok stores ->
          ({model | openStores = Just stores}, Cmd.none)
        Err e ->
          ({model | error = Just e}, Cmd.none)

    GotGeoloc result ->
      case result of
        Err err ->
          ({model | userLocation = Err err}, Cmd.none)
        Ok location ->
          ({model | userLocation = Ok (Just location)}, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Geolocation.changes (GotGeoloc << Ok)
