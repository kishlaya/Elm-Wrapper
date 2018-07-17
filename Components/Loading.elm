module Components.Loading exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Bootstrap.Progress as Progress

type alias Model = { done: Int }

type Msg = NoOp

view : Model -> Html Msg
view model =
  case model.done of
    0 ->
      text ""
    _ ->
      Progress.progress
        [ Progress.warning
        , Progress.animated
        , Progress.value 100
        ]


init : (Model, Cmd Msg)
init = ({ done = 0 }, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = (model, Cmd.none)
