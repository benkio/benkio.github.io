module Main exposing (..)

import Browser exposing (element)
import Html exposing (Html, button, div, input, p, text)
import Html.Attributes as A exposing (class, id, max, min, step, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Maybe exposing (withDefault)
import String exposing (fromInt, toInt)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { bpm : Int
    , isPlaying : Bool
    }



-- Init -------------------------------------------------------------------


init : () -> ( Model, Cmd msg )
init _ =
    ( { bpm = 100, isPlaying = False }, Cmd.none )



-- Update -----------------------------------------------------------------


type Msg
    = BpmChanged Int
    | Start
    | Stop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BpmChanged bpm ->
            ( { model | bpm = bpm }, Cmd.none )

        Start ->
            ( { model | isPlaying = True }, Cmd.none )

        Stop ->
            ( { model | isPlaying = False }, Cmd.none )



-- Subscriptions ----------------------------------------------------------


subscriptions : Model -> Sub msg
subscriptions _ =
    Sub.none



-- View -------------------------------------------------------------------


view : Model -> Html Msg
view model =
    div [ id "sliderContainer" ]
        [ controls model
        , slider model.bpm
        ]


controls : Model -> Html Msg
controls model =
    div []
        [ p
            [ id "bpmSliderValue"
            , style "float" "left"
            , style "width" "70%"
            , style "text-align" "center"
            , style "padding-top" ".5em"
            , style "font-size" "large"
            ]
            [ text ("BPM: " ++ fromInt model.bpm) ]
        , div [ style "float" "left", style "width" "30%" ] [ startButton model.isPlaying ]
        ]


startButton : Bool -> Html Msg
startButton isPlaying =
    if isPlaying then
        button [ style "width" "30%", style "margin" "auto", style "margin-bottom" "1em", class "btn btn-danger", onClick Stop ] [ text "Stop" ]

    else
        button [ style "width" "30%", style "margin" "auto", style "margin-bottom" "1em", class "btn btn-success", onClick Start ] [ text "Start" ]


slider : Int -> Html Msg
slider bpm =
    input
        [ type_ "range"
        , A.min "40"
        , A.max "250"
        , value (fromInt bpm)
        , id "bpmSlider"
        , step "5"
        , style "width" "80%"
        , style "margin" "auto"
        , onInput (toInt >> withDefault 60 >> BpmChanged)
        ]
        []
