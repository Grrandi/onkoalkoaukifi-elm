-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/http.html

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL

type alias Stores = {open: Int, closed: Int}

type alias StoreInfos = {name: String, openHours: String}

type alias Model =
  { closedCount : Int
  , openCount : Int
  }


init : (Model, Cmd Msg)
init =
  ( Model 0 0
  , getOpenAlkos
  )



-- UPDATE


type Msg
  = GotCount (Result Http.Error Stores)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of

    GotCount (Ok res) ->
      (Model res.open res.closed, Cmd.none)

    GotCount (Err er) ->
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text <| toString model]
    , br [] []
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP

getOpenAlkoInfo : Cmd Msg
getOpenAlkoInfo =
    let
        url =
          "http://localhost:5000/open_stores"
    in
        Http.send GotInfo (Http.get url decodeInfo)

getOpenAlkos : Cmd Msg
getOpenAlkos =
  let
    url =
      --"https://gist.githubusercontent.com/Grrandi/4a819a79ee4ab3d5b75a6f08a826fa96/raw/47624ba7c1eb09487139676f64789417cfeceece/.json"
      "http://localhost:5000/open_store_count"
  in
    Http.send GotCount (Http.get url decodeCount)


decodeInfo : Decode.Decoder


decodeCount : Decode.Decoder Stores
decodeCount =
  Decode.map2 Stores
    (Decode.field "open" Decode.int)
    (Decode.field "closed" Decode.int)

decodeGifUrl : Decode.Decoder String
decodeGifUrl =
  Decode.at ["data", "image_url"] Decode.string
