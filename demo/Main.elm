module Main
  exposing (..)

import HttpWrapper
import Html exposing (..)
import Http
import Task
import Json.Decode
import Json.Encode exposing (Value)
import Json.Helpers exposing (..)

main = 
  Html.program
    { view = view
    , init = init
    , update = update
    , subscriptions = \_ -> Sub.none
    }

type alias Model = Data

type Msg
  = WrapperMsg (HttpWrapper.HttpResult Data)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    WrapperMsg (HttpWrapper.HttpResult (Ok result)) -> result ! []
    WrapperMsg (HttpWrapper.HttpResult (Err err)) -> model ! []

init : (Model, Cmd Msg)
init = (emptyData, load)

view : Model -> Html Msg
view model = 
  div []
    [ h1 [] [ text model.title ]
    , p [] [ text model.body ]
    ]

load : Cmd Msg
load = 
  let
    url = "https://jsonplaceholder.typicode.com/posts/1"
    request = Http.get url jsonDecData
  in
    HttpWrapper.send WrapperMsg request


-- Custom Data encodings/decodings

type alias Data =
  { userId : Int
  , id : Int
  , title : String
  , body : String
  }

emptyData : Data
emptyData = 
  { userId = 0
  , id = 0
  , title = "Blank title"
  , body = "Blank body"
  }

jsonDecData : Json.Decode.Decoder ( Data )
jsonDecData =
  ("userId" := Json.Decode.int) >>= \puserId ->
  ("id" := Json.Decode.int) >>= \pid ->
  ("title" := Json.Decode.string) >>= \ptitle ->
  ("body" := Json.Decode.string) >>= \pbody ->
  Json.Decode.succeed {userId = puserId, id = pid, title = ptitle, body = pbody}