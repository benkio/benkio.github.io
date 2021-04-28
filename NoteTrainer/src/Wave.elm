module Wave exposing (Wave(..), waveToString, toWave)

type Wave
    = Sine
    | Triangle
    | Square
    | Sawtooth


waveToString : Wave -> String
waveToString w =
    case w of
        Sine ->
            "sine"

        Triangle ->
            "triangle"

        Square ->
            "square"

        Sawtooth ->
            "sawtooth"


toWave : String -> Maybe Wave
toWave s =
    case s of
        "sine" ->
            Just Sine

        "triangle" ->
            Just Triangle

        "square" ->
            Just Square

        "sawtooth" ->
            Just Sawtooth

        _ ->
            Nothing
