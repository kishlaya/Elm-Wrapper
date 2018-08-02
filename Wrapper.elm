module Wrapper
  exposing (..)

import Http
import Task

type alias Model =
  { loading: Int
  }

type Msg a
  = HttpResult (Result Http.Error a)

update : (Msg a) -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    HttpResult result -> (model, Cmd.none)

send : ((Msg a) -> msg) -> (Http.Request a) -> Cmd msg
send wrapper request = Cmd.map wrapper <| Http.send HttpResult request

pure : msg -> Cmd msg
pure msg = Task.perform (always msg) (Task.succeed ())