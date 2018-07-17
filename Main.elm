module Main exposing (..)

import Types exposing (..)
import Pages.Feature as Feature
import Components.Loading as Loading
import Components.Alert as Alert
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Navigation
import Bootstrap.CDN as CDN
import Bootstrap.Alert exposing (shown)

main =
  Html.program {
    init = init
  , view = view
  , update = update
  , subscriptions = \_ -> Sub.none
  }

type alias Model =
  { featureModel : Feature.Model
  , loadingModel : Loading.Model
  , alertModel : Alert.Model
  }

type Msg
  = FeatureMsg Feature.Msg
  | LoadingMsg Loading.Msg
  | AlertMsg Alert.Msg

init : (Model, Cmd Msg)
init =
  let
    (featureModel_, featureCmd_) = Feature.init
    (loadingModel_, loadingCmd_) = Loading.init
    (alertModel_, alertCmd_) = Alert.init
  in
    ({ featureModel = featureModel_, loadingModel = loadingModel_, alertModel = alertModel_ }
    , Cmd.batch [ Cmd.map FeatureMsg featureCmd_
                , Cmd.map LoadingMsg loadingCmd_
                , Cmd.map AlertMsg alertCmd_
                ]
    )

view : Model -> Html Msg
view model =
  div []
    [ CDN.stylesheet
    , Html.map LoadingMsg <| Loading.view model.loadingModel
    , Html.map AlertMsg <| Alert.view model.alertModel
    , Html.map FeatureMsg <| Feature.view model.featureModel
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    FeatureMsg featureMsg ->
      let
        (newFeatureModel, newCmd) = Feature.update featureMsg model.featureModel
        oldLoadingModel = model.loadingModel
        oldAlertModel = model.alertModel
      in
        ( { model | featureModel = newFeatureModel
                  , loadingModel = { oldLoadingModel | done = newFeatureModel.done }
                  , alertModel   = { oldAlertModel | alertVisibility = shown, alertType = newFeatureModel.alertType }
          }
        , Cmd.map FeatureMsg newCmd
        )
    LoadingMsg loadingMsg ->
      let
        (newLoadingModel, newCmd) = Loading.update loadingMsg model.loadingModel
      in
        ({ model | loadingModel = newLoadingModel }, Cmd.map LoadingMsg newCmd)
    AlertMsg alertMsg ->
      let
        (newAlertModel, newCmd) = Alert.update alertMsg model.alertModel
      in
        ({ model | alertModel = newAlertModel }, Cmd.map AlertMsg newCmd)
