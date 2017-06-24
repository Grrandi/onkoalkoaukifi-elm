module Types exposing (..)

import Http

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

type Msg
  = GotCount (Result Http.Error Stores)
  | GotInfo (Result Http.Error (List StoreInfos))
