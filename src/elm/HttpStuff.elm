module HttpStuff exposing (..)

import Http
import Types exposing (..)
import AlkoDecoders exposing (..)

-- HTTP

getOpenAlkoInfo : Cmd Msg
getOpenAlkoInfo =
    let
        url =
          --"https://gist.githubusercontent.com/Grrandi/4a819a79ee4ab3d5b75a6f08a826fa96/raw/8a93ec5557f21fe510e81300c9a07ea8c4d4f617/object.json"
          "https://oaa-server.onkoalkoauki.fi/open_stores"
    in
        Http.send GotInfo fuufaa


fuufaa : Http.Request (List StoreInfos)
fuufaa =
    Http.get "https://oaa-server.onkoalkoauki.fi/open_stores" decodeStores

getOpenAlkos : Cmd Msg
getOpenAlkos =
  let
    url =
      --"https://gist.githubusercontent.com/Grrandi/4a819a79ee4ab3d5b75a6f08a826fa96/raw/47624ba7c1eb09487139676f64789417cfeceece/.json"
      "https://oaa-server.onkoalkoauki.fi/open_store_count"
  in
    Http.send GotCount (Http.get url decodeCount)
