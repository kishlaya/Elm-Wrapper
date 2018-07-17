module Main exposing (..)

import Types exposing (..)
import Pages.Feature as Feature
import Components.Loading as Loading
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Navigation
import Bootstrap.CDN as CDN

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
  , done : Bool
  }

type Msg
  = FeatureMsg Feature.Msg
  | LoadingMsg Loading.Msg

init : (Model, Cmd Msg)
init =
  let
    (featureModel_, featureCmd_) = Feature.init
    (loadingModel_, loadingCmd_) = Loading.init
  in
    ({ loadingModel = loadingModel_, featureModel = featureModel_, done = False }, Cmd.map FeatureMsg featureCmd_)

view : Model -> Html Msg
view model =
  div []
    [ CDN.stylesheet
    , Html.map LoadingMsg <| Loading.view model.loadingModel
    , Html.map FeatureMsg <| Feature.view model.featureModel
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    FeatureMsg featureMsg ->
      let
        (newFeatureModel, newCmd) = Feature.update featureMsg model.featureModel
      in
        ({ model | featureModel = newFeatureModel }, Cmd.map FeatureMsg newCmd)
    LoadingMsg loadingMsg ->
      let
        (newLoadingModel, newCmd) = Loading.update loadingMsg model.loadingModel
      in
        ({ model | loadingModel = newLoadingModel }, Cmd.map LoadingMsg newCmd)
