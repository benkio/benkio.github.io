module Note exposing (Note, allNotes, note, noteGenerator, a440)

import List exposing (concat, drop, map)
import Random exposing (Generator, weighted)
import String exposing (length)


type alias Note =
    { midiNumber : Int, frequency : Float, name : String }


a440 : Note
a440 = { midiNumber = 69, frequency = 440, name = "A" }
        
note : Int -> List Note
note midiNumber =
    case clamp 69 80 midiNumber of
        69 ->
            [ a440 ]

        70 ->
            [ { midiNumber = 70, frequency = 466.16, name = "A#" }
            , { midiNumber = 70, frequency = 466.16, name = "Bb" }
            ]

        71 ->
            [ { midiNumber = 71, frequency = 493.88, name = "B" } ]

        72 ->
            [ { midiNumber = 72, frequency = 523.25, name = "C" } ]

        73 ->
            [ { midiNumber = 73, frequency = 554.37, name = "C#" }
            , { midiNumber = 73, frequency = 554.37, name = "Db" }
            ]

        74 ->
            [ { midiNumber = 74, frequency = 587.33, name = "D" } ]

        75 ->
            [ { midiNumber = 75, frequency = 622.25, name = "Eb" }
            , { midiNumber = 75, frequency = 622.25, name = "D#" }
            ]

        76 ->
            [ { midiNumber = 76, frequency = 659.25, name = "E" } ]

        77 ->
            [ { midiNumber = 77, frequency = 698.46, name = "F" } ]

        78 ->
            [ { midiNumber = 78, frequency = 739.99, name = "Gb" }
            , { midiNumber = 78, frequency = 739.99, name = "F#" }
            ]

        79 ->
            [ { midiNumber = 79, frequency = 783.99, name = "G" } ]

        80 ->
            [ { midiNumber = 80, frequency = 830.61, name = "Ab" }
            , { midiNumber = 80, frequency = 830.61, name = "G#" }
            ]

        _ ->
            [ a440 ]


allNotes : List Note
allNotes =
    concat
        [ note 69
        , note 70
        , note 71
        , note 72
        , note 73
        , note 74
        , note 75
        , note 76
        , note 77
        , note 78
        , note 79
        , note 80
        ]


noteGenerator : Random.Generator Note
noteGenerator =
    weighted ( 10, a440 ) <|
        drop 1 <|
            map
                (\n ->
                    if length n.name == 1 then
                        ( 10, n )

                    else
                        ( 5, n )
                )
                allNotes
