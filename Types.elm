module Types exposing (..)

import Json.Decode
import Json.Encode exposing (Value)
import Json.Helpers exposing (..)

type Alert = Error String | Success | None

type alias Joke =
  { id: String
  , joke: String
  , status: Int
  }

jsonDecJoke : Json.Decode.Decoder ( Joke )
jsonDecJoke =
  ("id" := Json.Decode.string) >>= \pid ->
  ("joke" := Json.Decode.string) >>= \pjoke ->
  ("status" := Json.Decode.int) >>= \pstatus ->
  Json.Decode.succeed {id = pid, joke = pjoke, status = pstatus}
