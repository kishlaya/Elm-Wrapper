module Types exposing (..)

import Json.Decode
import Json.Encode exposing (Value)
import Json.Helpers exposing (..)

type LoadingCounter = Increment | Decrement | Stay

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

type alias User =
  { title: String
  , first: String
  , last: String
  }

jsonDecUser : Json.Decode.Decoder ( List User )
jsonDecUser = Json.Decode.at ["results"] <| Json.Decode.list <| Json.Decode.at ["name"] <|
  ("title" := Json.Decode.string) >>= \ptitle ->
  ("first" := Json.Decode.string) >>= \pfirst ->
  ("last" := Json.Decode.string) >>= \plast ->
  Json.Decode.succeed {title = ptitle, first = pfirst, last = plast}
