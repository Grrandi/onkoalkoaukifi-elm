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



-- Geocoords

-- // Convert Degress to Radians
-- function Deg2Rad(deg) {
--   return deg * Math.PI / 180;
-- }
--
-- function PythagorasEquirectangular(lat1, lon1, lat2, lon2) {
--   lat1 = Deg2Rad(lat1);
--   lat2 = Deg2Rad(lat2);
--   lon1 = Deg2Rad(lon1);
--   lon2 = Deg2Rad(lon2);
--   var R = 6371; // km
--   var x = (lon2 - lon1) * Math.cos((lat1 + lat2) / 2);
--   var y = (lat2 - lat1);
--   var d = Math.sqrt(x * x + y * y) * R;
--   return d;
-- }

convertDegtoRad: Float -> Float
convertDegtoRad deg =
  deg * pi / 180

pythagorasEquirectangular: Float -> Float -> Float -> Float -> Float
pythagorasEquirectangular lat1deg lon1deg lat2deg lon2deg =
  let
    lat1 = convertDegtoRad lat1deg
    lon1 = convertDegtoRad lon1deg
    lat2 = convertDegtoRad lat2deg
    lon2 = convertDegtoRad lon2deg
    r = 6371.0
    x = (*) (lon2 - lon1) <| cos <| (lat1 + lat2) / 2
    y = lat2 - lat1
  in
    sqrt <| (x*x + y*y) * r

-- shortestDistance: Float -> Float -> Order
-- shortestDistance currentShortest storeDist =
--   if currentShortest < storeDist then
--     LT
--   else if currentShortest > storeDist then
--     GT
--   else
--     EQ

recurseMF: Float -> StoreInfos -> Geolocation.Location -> List StoreInfos -> StoreInfos
recurseMF previousMin previousStore userLoc stores =
  case stores of
    [] -> StoreInfos "" "" 0.0 0.0 "" "" "" ""
    [x] ->
      let
        newDist = pythagorasEquirectangular userLoc.latitude userLoc.longitude x.latitude x.longitude
      in
        if newDist < previousMin then
          x
        else
          previousStore
    (x::xs) ->
      let
          newDist = pythagorasEquirectangular userLoc.latitude userLoc.longitude x.latitude x.longitude
      in
        if newDist < previousMin then
          recurseMF newDist x userLoc xs
        else
          recurseMF previousMin previousStore userLoc xs

deconstructResultsAndMaybes: Float -> StoreInfos -> Result -> List StoreInfos -> List StoreInfos
deconstructResultsAndMaybes previousMin previousStore userLoc stores =
  case userLoc of
    Err err -> stores
    Ok loc ->
      case loc of
        Just loc -> [recurseMF previousMin previousStore loc stores]
        Nothing -> stores
