port module Main exposing (..)

import Browser exposing (element)
import Html exposing (Html, a, audio, button, div, h1, h4, input, label, li, option, p, select, source, span, text, ul)
import Html.Attributes as A exposing (attribute, autoplay, class, controls, href, id, max, min, selected, src, step, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Html.Events.Extra exposing (onChange)
import Json.Encode as E exposing (Value, float, int, list, object)
import List exposing (filterMap, head)
import Maybe exposing (map, withDefault)
import Note exposing (Note(..), allNotes, noteGenerator, noteToFrequency, noteToString)
import Wave exposing (Wave(..), waveToString, toWave)
import Random exposing (generate)
import String exposing (append, contains, fromChar, fromInt, replace, toInt)
import Time exposing (every)


port play : E.Value -> Cmd msg


toMusic : Model -> E.Value
toMusic { notes, bpm, volume, oscillatorWave } =
    E.object
        [ ( "frequencies", E.list (noteToFrequency >> E.float) notes )
        , ( "seconds", E.float (bpmToSec bpm) )
        , ( "volume", E.int volume )
        , ( "oscillatorwave", E.string (waveToString oscillatorWave) )
        ]


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


bpmToMillis : Int -> Float
bpmToMillis bpm =
    toFloat 60000 / toFloat bpm


bpmToSec : Int -> Float
bpmToSec bpm =
    toFloat 60 / toFloat bpm



-- Init -------------------------------------------------------------------


type Filter
    = ChromaticScale
    | ByNoteTonality Note


type alias Model =
    { bpm : Int
    , volume : Int
    , isPlaying : Bool
    , notes : List Note
    , oscillatorWave : Wave
    , filter : Filter
    }


init : () -> ( Model, Cmd msg )
init _ =
    ( { bpm = 100, volume = 50, isPlaying = False, notes = [ A ], oscillatorWave = Sine, filter = ChromaticScale }, Cmd.none )



-- Update -----------------------------------------------------------------


type Msg
    = BpmChanged Int
    | VolumeChanged Int
    | WaveChanged String
    | FilterChange Filter
    | Start
    | NewNote Note
    | ChangeNote
    | Stop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BpmChanged bpm ->
            ( { model | bpm = bpm }, Cmd.none )

        VolumeChanged volume ->
            ( { model | volume = volume }, Cmd.none )

        WaveChanged wave ->
            ( { model | oscillatorWave = withDefault Sine (toWave wave) }, Cmd.none )

        FilterChange filter ->
            ( { model | filter = filter }, Cmd.none )

        Start ->
            ( { model | isPlaying = True }, Cmd.none )

        Stop ->
            ( { model | isPlaying = False }, Cmd.none )

        ChangeNote ->
            ( model, generate NewNote noteGenerator )

        NewNote n ->
            ( { model | notes = [ n ] }, play (toMusic model) )



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
    div [ id "sliderContainer", style "width" "100%" ]
        [ noteTrainerControls model
        , slider model.bpm
        , optionPanel model
        , note (withDefault A (head model.notes))
        ]


noteTrainerControls : Model -> Html Msg
noteTrainerControls model =
    div []
        [ div
            [ style "display" "flex"
            , style "flex-direction" "row"
            , style "justify-content" "center"
            , style "align-items" "center"
            ]
            [ div [ style "margin-right" ".5em" ] [ p [ id "bpmSliderValue", style "font-size" "large", style "margin" "auto" ] [ text ("BPM: " ++ fromInt model.bpm) ] ]
            , div [ style "margin-right" ".5em", style "margin-left" ".5em" ] [ startButton model.isPlaying ]
            , div [ style "text-align" "center", style "margin-left" ".5em" ]
                [ p [ style "margin-bottom" "0px" ] [ text "🔉" ]
                , input
                    [ type_ "range"
                    , A.min "0"
                    , A.max "100"
                    , value (fromInt model.volume)
                    , id "volumeSlider"
                    , style "width" "100px"
                    , style "margin-left" "auto"
                    , style "margin-right" "auto"
                    , onInput (toInt >> withDefault 60 >> VolumeChanged)
                    ]
                    []
                ]
            ]
        ]


startButton : Bool -> Html Msg
startButton isPlaying =
    let
        ( msg, btnClass, btnText ) =
            case isPlaying of
                True ->
                    ( Stop, "btn-danger", "Stop" )

                False ->
                    ( Start, "btn-success", "Start" )
    in
    button
        [ style "min-width" "80px"
        , style "margin" "auto"
        , style "margin-bottom" "1em"
        , style "margin-top" "1em"
        , class "btn"
        , class btnClass
        , onClick msg
        ]
        [ text btnText ]


slider : Int -> Html Msg
slider bpm =
    div [ style "max-width" "500px", style "margin" "auto" ]
        [ input
            [ type_ "range"
            , A.min "20"
            , A.max "220"
            , value (fromInt bpm)
            , id "bpmSlider"
            , step "5"
            , style "margin-top" "1em"
            , onInput (toInt >> withDefault 60 >> BpmChanged)
            ]
            []
        ]


note : Note -> Html Msg
note n =
    div
        [ style "min-width" "300px"
        , style "text-align" "center"
        ]
        [ p [ style "font-size" "13em" ] [ text (noteToString n) ]
        ]


optionPanel : Model -> Html Msg
optionPanel model =
    div [ class "panel-group", style "text-align" "center", style "margin" "1em auto", style "max-width" "500px" ]
        [ div [ class "panel", class "panel-default" ]
            [ div [ class "panel-heading" ]
                [ h4 [ class "panel-title" ]
                    [ a [ attribute "data-toggle" "collapse", href "#collapseOptions" ]
                        [ text "Note Trainer Options"
                        ]
                    ]
                ]
            , div [ id "collapseOptions", class "panel-collapse", class "collapse" ]
                [ panelBody model
                ]
            ]
        ]


panelBody : Model -> Html Msg
panelBody model =
    let
        ( chromaticScaleClass, tonalityClass, tonalityKey ) =
            case model.filter of
                ChromaticScale ->
                    ( "btn-primary", "btn-link", Nothing )

                ByNoteTonality n ->
                    ( "btn-link", "btn-primary", Just (noteToString n) )
    in
    div [ class "panel-body" ]
        [ div []
            [ label [ style "display" "inline-block", style "color" "black", style "margin-right" "1em" ] [ text "Waveform" ]
            , select
                [ id "waveForm"
                , style "color" "black"
                , style "min-width" "80px"
                , style "margin" "auto"
                , style "margin-bottom" "1em"
                , style "margin-top" "1em"
                , onChange WaveChanged
                ]
                [ option [ selected True, value "sine" ] [ text "Sine" ]
                , option [ value "triangle" ] [ text "Triangle" ]
                , option [ value "square" ] [ text "Square" ]
                , option [ value "sawtooth" ] [ text "Sawtooth" ]
                ]
            ]
        , div [ class "btn-group" ]
            [ button
                [ class "btn"
                , class chromaticScaleClass
                , onClick (FilterChange ChromaticScale)
                ]
                [ text "Chromatic Scale" ]
            , tonalityButtonGroup tonalityClass tonalityKey
            ]
        ]


tonalityButtonGroup : String -> Maybe String -> Html Msg
tonalityButtonGroup tonalityClass tonalityKey =
    let
        menuElements =
            filterMap
                (\n ->
                    case ( contains "b" (noteToString n), (map (\tn -> noteToString n == tn) >> (\x -> withDefault False x)) tonalityKey ) of
                        ( True, _ ) ->
                            Nothing

                        ( False, True ) ->
                            Just (li [] [ a [ onClick (FilterChange (ByNoteTonality n)), class "bg-primary" ] [ text (noteToString n) ] ])

                        ( False, False ) ->
                            Just (li [] [ a [ onClick (FilterChange (ByNoteTonality n)) ] [ text (noteToString n) ] ])
                )
                allNotes
    in
    div [ class "btn-group" ]
        [ button
            [ id "byTonalityDropdown"
            , class "btn"
            , class tonalityClass
            , class "dropdown-toggle"
            , attribute "data-toggle" "dropdown"
            ]
            [ text ((map (append "Tonality ") >> withDefault "By Tonality") tonalityKey)
            , span [ class "caret" ] []
            ]
        , ul [ class "dropdown-menu", attribute "role" "menu" ] menuElements
        ]
