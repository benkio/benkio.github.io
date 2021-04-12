module Main exposing (..)

import Browser exposing (element)
import Html exposing (Html, text, div)


main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model = {}

-- Init -------------------------------------------------------------------
init : () -> ( Model, Cmd msg )
init _ = ({}, Cmd.none)

-- Update -----------------------------------------------------------------
update : msg -> Model -> ( Model, Cmd msg )
update _ _ = ({}, Cmd.none)

-- Subscriptions ----------------------------------------------------------
subscriptions : Model -> Sub msg
subscriptions _ = Sub.none

-- View -------------------------------------------------------------------
view : Model -> Html msg
view _ = div [] [text "hello world"]
