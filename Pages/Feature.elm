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
import Bootstrap.Button as Button

type alias Model =
  { joke: String
  , allowNext : Bool
  , loadingCounter: LoadingCounter
  , alertType : Alert
  }

emptyJoke = "Click button for laughter"
emptyModel = { joke = emptyJoke, allowNext = False, loadingCounter = Stay, alertType = None }

type Msg = NextJoke | ShowJoke (Result Http.Error Joke)

init : (Model, Cmd Msg)
init = (emptyModel, Cmd.none)

view : Model -> Html Msg
view model =
  Grid.container []
    [ Card.config [ Card.outlineDark ]
        |> Card.headerH1 [] [ text "Joke generator" ]
        |> Card.footer [] [ text "Using icanhazdadjoke" ]
        |> Card.block []
            [ Block.text [] [ text model.joke ]
            , Block.custom
                <| Button.button
                    [ Button.primary
                    , Button.onClick NextJoke
                    , Button.disabled <| not (model.allowNext)
                    ] [text "Next one"]
            ]
        |> Card.view
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ShowJoke (Ok result) -> ({ model | joke = result.joke, loadingCounter = Decrement, alertType = Success, allowNext = True }, Cmd.none)
    ShowJoke (Err err) -> ({ model | joke = emptyJoke, loadingCounter = Decrement, alertType = Error (toString err), allowNext = True }, Cmd.none)
    NextJoke -> ({ model | joke = emptyJoke, loadingCounter = Increment, alertType = None, allowNext = False }, load)

load : Cmd Msg
load =
  let
    url = "https://icanhazdadjoke.com/"
    request =
      Http.request
        { method = "GET"
        , headers = [Http.header "Accept" "application/json"]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson jsonDecJoke
        , timeout = Nothing
        , withCredentials = False
        }
  in
    Http.send ShowJoke request
