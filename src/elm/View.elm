module View exposing (view)

import Types exposing (..)
import Html exposing (div, p, span, text, Html, h2, br)
import Html.Attributes as Attributes



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
    , br [] []
    , p []
      [ span [] [text "Alkoja auki: "]
      , span [] [text <| toString model.openCount]]
    , p []
      [ span [] [text "Alkoja kiinni: "]
      , span [] [text <| toString (model.totalCount - model.openCount)]]
    , div []
      [ p []
        [ span [] [text "Prosenttia auki: "]
        , span [] [text <| toString <| openPercentage model.openCount model.totalCount]]

      ]
    , percentageText <| openPercentage model.openCount model.totalCount
    ]
