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

type alias StoreInfos =
  { name: String
  , city: String
  , latitude: Float
  , longitude: Float
  , phone: String
  , postalCode: String
  , address: String
  , openHours: String
  }

type alias Model =
  { openCount : Int
  , totalCount : Int
  , error : Maybe Http.Error
  , openStores : Maybe (List StoreInfos)
  }


init : (Model, Cmd Msg)
init =
  ( Model 0 0 Nothing Nothing
  , Cmd.batch [getOpenAlkos, getOpenAlkoInfo]
  )

-- UPDATE

type Msg
  = GotCount (Result Http.Error Stores)
  | GotInfo (Result Http.Error (List StoreInfos))


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



-- VIEW FUNCTIONS

openPercentage: Int -> Int -> Float
openPercentage open total =
  case total of
    0 ->
      0
    _ ->
      (*) 100 <| toFloat open / toFloat total

percentageText: Float -> Html Msg
percentageText percent =
  if percent <= 0 then
    div []
      [ p [] [text "Lol, kaikki kiinni. Too lates"]
      ]
  else if percent <= 5 then
    div []
      [ p [] [text "Nyt mahtaapi olla jo aikamoinen kiire"]
      ]
  else if percent <= 50 then
    div []
      [ p [] [text "Kohta taitaapi olla kiire"]
      ]
  else if percent <= 90 then
    div []
      [ p [] [text "Ei mitään hätiä"]
      ]
  else
    div []
      [ p [] [text "Dunno lol"]
      ]

-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text "Onko alko auki?!"]
    , br [] []
    , p []
      [ span [] [text "Alkoja auki: "]
      , span [] [text <| toString model.openCount]]
      , br [] []
      , span [] [text "Alkoja kiinni: "]
      , span [] [text <| toString (model.totalCount - model.openCount)]
    , div []
      [ p []
        [ span [] [text "Prosenttia auki: "]
        , span [] [text <| toString <| openPercentage model.openCount model.totalCount]]

      ]
    , percentageText <| openPercentage model.openCount model.totalCount
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
          --"https://gist.githubusercontent.com/Grrandi/4a819a79ee4ab3d5b75a6f08a826fa96/raw/8a93ec5557f21fe510e81300c9a07ea8c4d4f617/object.json"
          "http://localhost:5000/open_stores"
    in
        Http.send GotInfo fuufaa


fuufaa : Http.Request (List StoreInfos)
fuufaa =
    Http.get "http://localhost:5000/open_stores" decodeStores

getOpenAlkos : Cmd Msg
getOpenAlkos =
  let
    url =
      --"https://gist.githubusercontent.com/Grrandi/4a819a79ee4ab3d5b75a6f08a826fa96/raw/47624ba7c1eb09487139676f64789417cfeceece/.json"
      "http://localhost:5000/open_store_count"
  in
    Http.send GotCount (Http.get url decodeCount)

decodeStores : Decode.Decoder (List StoreInfos)
decodeStores =
    Decode.at ["shoppens"] (Decode.list decodeStore)

decodeStore : Decode.Decoder StoreInfos
decodeStore =
    Decode.map8
      StoreInfos
      (Decode.at ["name"] Decode.string)
      (Decode.at ["city"] Decode.string)
      (Decode.at ["latitude"] Decode.float)
      (Decode.at ["longitude"] Decode.float)
      (Decode.at ["phone"] Decode.string)
      (Decode.at ["postalCode"] Decode.string)
      (Decode.at ["address"] Decode.string)
      (Decode.at ["OpenDay0"] Decode.string)



decodeCount : Decode.Decoder Stores
decodeCount =
  Decode.map2 Stores
    (Decode.field "open" Decode.int)
    (Decode.field "total" Decode.int)
