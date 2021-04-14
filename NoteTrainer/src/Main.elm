port module Main exposing (..)

import Browser exposing (element)
import Html exposing (Html, audio, button, div, h1, input, p, source, text)
import Html.Attributes as A exposing (autoplay, class, controls, id, max, min, src, step, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Maybe exposing (withDefault)
import Note exposing (Note, noteGenerator, noteToString)
import Random exposing (generate)
import String exposing (fromChar, fromInt, replace, toInt)
import Time exposing (every)


port playNote : String -> Cmd msg


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


noteToMP3 : String -> String
noteToMP3 n =
    "./notes/" ++ replace "#" "sharp" n ++ ".mp3"



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
            ( { model | note = noteToString n }, playNote (noteToMP3 (noteToString n)) )



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
    div [ id "sliderContainer", style "display" "table", style "width" "100%" ]
        [ noteTrainerControls model
        , slider model.bpm
        , note model.note
        ]


noteTrainerControls : Model -> Html Msg
noteTrainerControls model =
    div [style "display" "table-row"]
        [ div [ style "display" "table-cell"
              , style "text-align" "center"
              , style "min-width" "100px"
              , style "width" "20%"] [
               p
            [ id "bpmSliderValue"
            , style "font-size" "large"
            ]
            [ text ("BPM: " ++ fromInt model.bpm) ]]
        , div [ style "display" "table-cell"
              , style "text-align" "center"
              , style "width" "60%"
              ] [ startButton model.isPlaying ]
        , div [style "display" "table-cell"
              ,style "text-align" "center"
              , style "width" "20%"
              ]
            [audio [ id "notePlayer"
                , controls True
                , style "width" "100px"
                , style "vertical-align" "middle"
                ] [ source [ id "notePlayerSource" ] [] ]]
        ]


startButton : Bool -> Html Msg
startButton isPlaying =
    if isPlaying then
        button [ 
                style "min-width" "80px"
               , style "margin" "auto"
               , style "margin-bottom" "1em"
               , style "margin-top" "1em"
               , class "btn btn-danger"
               , onClick Stop ] [ text "Stop" ]

    else
        button [
                style "min-width" "80px"
               , style "margin" "auto"
               , style "margin-bottom" "1em"
               , style "margin-top" "1em"
               , class "btn btn-success"
               , onClick Start ] [ text "Start" ]


slider : Int -> Html Msg
slider bpm =
    div [ style "display" "table-row", style "width" "100%"]
        [
         div [style "display" "table-cell", style "width" "20%"] []
         ,div [style "display" "table-cell", style "width" "60%"]
         [input
        [ type_ "range"
        , A.min "20"
        , A.max "220"
        , value (fromInt bpm)
        , id "bpmSlider"
        , step "5"
        , onInput (toInt >> withDefault 60 >> BpmChanged)
        ]
        []]
        ,div [style "display" "table-cell", style "width" "20%"] []]


note : String -> Html Msg
note n =
    div [style "display" "table-row"]
    [
     div [style "display" "table-cell", style "width" "25%"] []
     ,div [style "display" "table-cell"
          , style "width" "50%"
          , style "min-width" "300px"
          , style "text-align" "center"] [
          p [ style "font-size" "15em"] [ text n ]]
    , div [style "display" "table-cell", style "width" "25%"] []
    ]
