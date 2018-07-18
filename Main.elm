module Main exposing (..)

import Types exposing (..)
import Pages.Feature as Feature
import Pages.FakeUser as FakeUser
import Components.Loading as Loading
import Components.Alert as Alert
import Task
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Navigation
import Bootstrap.Grid as Grid
import Bootstrap.CDN as CDN
import Bootstrap.Button as Button
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
  , fakeuserModel : FakeUser.Model
  , loadingModel : Loading.Model
  , alertModel : Alert.Model
  }

type Msg
  = FeatureMsg Feature.Msg
  | FakeUserMsg FakeUser.Msg
  | LoadingMsg Loading.Msg
  | AlertMsg Alert.Msg
  | Generate

init : (Model, Cmd Msg)
init =
  let
    (featureModel_, featureCmd_) = Feature.init
    (fakeuserModel_, fakeuserCmd_) = FakeUser.init
    (loadingModel_, loadingCmd_) = Loading.init
    (alertModel_, alertCmd_) = Alert.init
  in
    ({ featureModel = featureModel_, fakeuserModel = fakeuserModel_, loadingModel = loadingModel_, alertModel = alertModel_ }
    , Cmd.batch [ Cmd.map FeatureMsg featureCmd_
                , Cmd.map FakeUserMsg fakeuserCmd_
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
    , Grid.container []
        [ Grid.simpleRow
            [ Grid.col [] [ Html.map FeatureMsg <| Feature.view model.featureModel ]
            , Grid.col [] [ Html.map FakeUserMsg <| FakeUser.view model.fakeuserModel ]
            ]
        , Button.button [ Button.primary, Button.onClick Generate ] [ text "Generate" ]
        ]
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
                  , loadingModel = { oldLoadingModel | done = updateLoader oldLoadingModel.done newFeatureModel.loadingCounter }
                  , alertModel   = { oldAlertModel | alertVisibility = shown, alertType = newFeatureModel.alertType }
          }
        , Cmd.map FeatureMsg newCmd
        )
    FakeUserMsg fakeuserMsg ->
      let
        (newFakeuserModel, newCmd) = FakeUser.update fakeuserMsg model.fakeuserModel
        oldLoadingModel = model.loadingModel
        oldAlertModel = model.alertModel
      in
        ( { model | fakeuserModel = newFakeuserModel
                  , loadingModel  = { oldLoadingModel | done = updateLoader oldLoadingModel.done newFakeuserModel.loadingCounter }
                  , alertModel    = { oldAlertModel | alertVisibility = shown, alertType = newFakeuserModel.alertType }
          }
        , Cmd.map FakeUserMsg newCmd
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
    Generate ->
      model ! [ Cmd.map FakeUserMsg <| Task.perform (always FakeUser.NextUser) (Task.succeed 0)
              , Cmd.map FeatureMsg <| Task.perform (always Feature.NextJoke) (Task.succeed 0)
              ]

updateLoader : Int -> LoadingCounter -> Int
updateLoader n lc =
  case lc of
    Increment -> n+1
    Decrement -> n-1
    Stay -> n
