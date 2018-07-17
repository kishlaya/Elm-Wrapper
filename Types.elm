module Types exposing (..)

import Json.Decode
import Json.Encode exposing (Value)
import Json.Helpers exposing (..)

type Alert = Error String | Success | None

type alias Attachment =
  { fallback: String
  , footer: String
  , text: String
  }

type alias Joke =
  { attachments: List Attachment
  , response_type: String
  , username: String
  }

jsonDecAttachment : Json.Decode.Decoder ( Attachment )
jsonDecAttachment =
  ("fallback" := Json.Decode.string) >>= \pfallback ->
  ("footer" := Json.Decode.string) >>= \pfooter ->
  ("text" := Json.Decode.string) >>= \ptext ->
  Json.Decode.succeed {fallback = pfallback, footer = pfooter, text = ptext}

jsonDecJoke : Json.Decode.Decoder ( Joke )
jsonDecJoke =
   ("attachments" := Json.Decode.list (jsonDecAttachment)) >>= \pattachments ->
   ("response_type" := Json.Decode.string) >>= \presponse_type ->
   ("username" := Json.Decode.string) >>= \pusername ->
   Json.Decode.succeed {attachments = pattachments, response_type = presponse_type, username = pusername}
