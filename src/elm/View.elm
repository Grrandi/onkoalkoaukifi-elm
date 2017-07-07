module View exposing (view)

import Types exposing (..)
import Html exposing (div, p, span, text, Html, h2, br, h4, h3)
import Html.Attributes as Attributes
import App exposing (deconstructResultsAndMaybes)


-- VIEW FUNCTIONS

openPercentage: Int -> Int -> Float
openPercentage open total =
  case total of
    0 ->
      0
    _ ->
      (*) 100 <| toFloat open / toFloat total

percentageText: Float -> String
percentageText percent =
  if percent <= 0 then
    "Onneksi huomenna on uusi päivä"
  else if percent <= 20 then
    "Nyt mahtaapi olla jo aikamoinen kiire"
  else if percent <= 50 then
    "Ettei vaan tulisi kiire"
  else if percent <= 93 then
    "Ei mitään hätiä"
  else if percent == 100 then
    "Kaikki auki!"
  else
    "dunno lol!"

alkoListItem: StoreInfos -> Html Msg
alkoListItem item =
  div [Attributes.class "list-group-item"]
    [ h4 [Attributes.class "list-group-item-heading" ] [text item.name]
    , div [Attributes.class "list-group-item-body"]
      [ p [] [text item.openHours]
      , p [] [text item.address]
      , p [] [text item.postalCode]
      , p [] [text item.city]]
    ]

alkoList: Maybe (List StoreInfos) -> List (Html Msg)
alkoList stores =
  case stores of
    Just stores -> List.map alkoListItem stores
    Nothing -> []

alkojaAuki: Int -> String
alkojaAuki c =
    if c>0 then
      "ON!"
    else
      "Ei oo :'("

-- VIEW


view : Model -> Html Msg
view model =
  div [ Attributes.class "app-container"]
    [ h2 [] [text <| alkojaAuki model.openCount]
    , div []
      [ p [] [text <| percentageText <| openPercentage model.openCount model.totalCount]
      ]
    , br [] []
--    , p []
--      [ span [] [text "Alkoja auki: "]
--      , span [] [text <| toString model.openCount]
--      ]
--    , p []
--      [ span [] [text "Alkoja kiinni: "]
--      , span [] [text <| toString (model.totalCount - model.openCount)]
--      ]
--    , div []
--      [ p []
--        [ span [] [text "Alkoista nyt "]
--        , span [] [text <| toString <| openPercentage model.openCount model.totalCount]
--        , span [] [text "% auki"]
--        ]
--      ]
    , div []
      [ h3 [] [text "Lähin auki oleva Alko:"]
      ]
    , div [Attributes.class "open-stores list-group"]
      <| alkoList <| deconstructResultsAndMaybes 99999.0 (StoreInfos "" "" 0.0 0.0 "" "" "" "") model.userLocation model.openStores

    ]
