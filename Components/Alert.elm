module Components.Alert exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Bootstrap.Alert as Alert

type alias Model =
  { alertVisibility : Alert.Visibility
  , alertType : Alert
  }

type Msg
    = AlertMsg Alert.Visibility

init : (Model, Cmd Msg)
init =
    ( { alertVisibility = Alert.shown, alertType = Success }, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AlertMsg visibility ->
            ( { model | alertVisibility = visibility }, Cmd.none )

view : Model -> Html Msg
view model =
  case model.alertType of
    Error err ->
      Alert.config
          |> Alert.dismissableWithAnimation AlertMsg
          |> Alert.danger
          |> Alert.children
              [ Alert.h4 [] [ text "Error occurred!" ]
              , text err
              ]
          |> Alert.view model.alertVisibility
    Success ->
      Alert.config
          |> Alert.dismissableWithAnimation AlertMsg
          |> Alert.success
          |> Alert.children
              [ Alert.h4 [] [ text "Success!" ]
              , text "Joke generated successfully"
              ]
          |> Alert.view model.alertVisibility
    None ->
      div [] []


-- Subscriptions are only needed when you choose to use dismissableWithAnimation

subscriptions : Model -> Sub Msg
subscriptions model =
    Alert.subscriptions model.alertVisibility AlertMsg
