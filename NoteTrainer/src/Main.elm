module Main exposing (..)

import Browser exposing (element)
import Html exposing (Html, button, div, h1, input, p, text)
import Html.Attributes as A exposing (class, id, max, min, step, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Maybe exposing (withDefault)
import Note exposing (Note, noteGenerator, noteToString)
import Random exposing (generate)
import String exposing (fromChar, fromInt, toInt)
import Time exposing (every)


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
    , note : String
    }


bpmToMillis : Int -> Float
bpmToMillis bpm =
    toFloat 60000 / toFloat bpm



-- Init -------------------------------------------------------------------


init : () -> ( Model, Cmd msg )
init _ =
    ( { bpm = 100, isPlaying = False, note = "A" }, Cmd.none )



-- Update -----------------------------------------------------------------


type Msg
    = BpmChanged Int
    | Start
    | NewNote Note
    | ChangeNote
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

        ChangeNote ->
            ( model, generate NewNote noteGenerator )

        NewNote n ->
            ( { model | note = noteToString n }, Cmd.none )



-- Subscriptions ----------------------------------------------------------


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.isPlaying of
        True ->
            every (bpmToMillis model.bpm) (\_ -> ChangeNote)

        False ->
            Sub.none



-- View -------------------------------------------------------------------


view : Model -> Html Msg
view model =
    div [ id "sliderContainer" ]
        [ controls model
        , slider model.bpm
        , note model.note
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
        , A.min "20"
        , A.max "220"
        , value (fromInt bpm)
        , id "bpmSlider"
        , step "5"
        , style "width" "80%"
        , style "margin" "auto"
        , onInput (toInt >> withDefault 60 >> BpmChanged)
        ]
        []


note : String -> Html Msg
note n =
    p [ style "font-size" "15em", style "text-align" "center" ] [ text n ]
