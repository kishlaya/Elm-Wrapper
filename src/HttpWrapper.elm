module HttpWrapper
  exposing (..)

import Http
import Task

type alias Model = ()

type HttpResult a
  = HttpResult (Result Http.Error a)

send : ((HttpResult a) -> msg) -> (Http.Request a) -> Cmd msg
send wrapper request = Cmd.map wrapper <| Http.send HttpResult request