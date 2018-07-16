module Pages.Feature exposing (..)

import Types exposing (..)
import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block

type alias Model =
  { joke: String
  , loading: Bool
  }
emptyModel = { joke = emptyAttachment.text, loading = False }

emptyAttachment =
  { fallback = ""
  , footer = ""
  , text = "<< fetching joke >>"
  }

type Msg = ShowJoke (Result Http.Error Joke)

init : (Model, Cmd Msg)
init = (emptyModel, load)

view : Model -> Html Msg
view model =
  Grid.container []
    [ Card.config [ Card.outlineDark ]
        |> Card.headerH1 [] [ text "Joke of the day" ]
        |> Card.footer [] [ text "Using icanhazdadjoke" ]
        |> Card.block []
            [ Block.text [] [ text model.joke ]
            ]
        |> Card.view
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ShowJoke (Ok joke) -> ({ model | joke = getJoke joke, loading = True }, Cmd.none)
    _ -> model ! []

load : Cmd Msg
load =
  let
    url = "https://icanhazdadjoke.com/slack"
    request = Http.get url jsonDecJoke
  in
    Http.send ShowJoke request

getJoke : Joke -> String
getJoke = .text << Maybe.withDefault emptyAttachment << List.head << .attachments
