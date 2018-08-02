module Wrapper
  exposing (..)

import Http
import Task

type alias Model =
  { loading: Int
  }

type Msg msg a
  = SendRequest (Result Http.Error a -> msg) (Result Http.Error a)

update : (Msg msg a) -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    SendRequest externalMsg result -> (model, pure <| externalMsg result)

send : ((Msg msg a) -> msg) -> (Result Http.Error a -> msg) -> (Http.Request a) -> Cmd msg
send wrapper externalMsg request = Cmd.map wrapper <| Http.send (SendRequest externalMsg) request

pure : msg -> Cmd msg
pure msg = Task.perform (always msg) (Task.succeed ())