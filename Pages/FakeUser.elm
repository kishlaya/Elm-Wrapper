module Pages.FakeUser exposing (..)

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
import Json.Decode

type alias Model =
  { user: User
  , allowNext : Bool
  , loadingCounter: LoadingCounter
  , alertType : Alert
  }

emptyUser : User
emptyUser =
  { title = ""
  , first = "Anonymous"
  , last = ""
  }
emptyModel = { user = emptyUser, allowNext = False, loadingCounter = Stay, alertType = None }

type Msg = NextUser | ShowUser (Result Http.Error (List User))

init : (Model, Cmd Msg)
init = (emptyModel, Cmd.none)

view : Model -> Html Msg
view model =
  Grid.container []
    [ Card.config [ Card.outlineDark ]
        |> Card.headerH1 [] [ text "User generator" ]
        |> Card.footer [] [ text "Using uinames" ]
        |> Card.block []
            [ Block.text [] [ text <| getName model.user ]
            , Block.custom
                <| Button.button
                    [ Button.primary
                    , Button.onClick NextUser
                    , Button.disabled <| not (model.allowNext)
                    ] [text "Next one"]
            ]
        |> Card.view
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ShowUser (Ok result) -> ({ model | user = Maybe.withDefault emptyUser (List.head result), loadingCounter = Decrement, alertType = Success, allowNext = True }, Cmd.none)
    ShowUser (Err err) -> ({ model | user = emptyUser, loadingCounter = Decrement, alertType = Error (toString err), allowNext = True }, Cmd.none)
    NextUser -> ({ model | user = emptyUser, loadingCounter = Increment, alertType = None, allowNext = False }, load)

load : Cmd Msg
load =
  let
    url = "https://randomuser.me/api"
    request = Http.get url jsonDecUser
  in
    Http.send ShowUser request

getName : User -> String
getName { title, first, last } = title ++ " " ++ first ++ " " ++ last
