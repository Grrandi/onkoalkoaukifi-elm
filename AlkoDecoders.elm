module AlkoDecoders exposing (decodeStores, decodeStore, decodeCount)

import Json.Decode as Decode
import Types exposing (..)

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
