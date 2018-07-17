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
    Alert.config
        |> Alert.dismissableWithAnimation AlertMsg
        |> getAlertColour model
        |> Alert.children
            [ Alert.h4 [] [ text "Alert heading" ]
            , text "This info message has a "
            , Alert.link [ href "javascript:void()" ] [ text "link" ]
            , p [] [ text "Followed by a paragraph behaving as you'd expect." ]
            ]
        |> Alert.view model.alertVisibility


-- Subscriptions are only needed when you choose to use dismissableWithAnimation

subscriptions : Model -> Sub Msg
subscriptions model =
    Alert.subscriptions model.alertVisibility AlertMsg

getAlertColour : Model -> Alert.Config Msg -> Alert.Config Msg
getAlertColour model =
  case model.alertType of
    Error _ -> Alert.danger
    Success -> Alert.success
