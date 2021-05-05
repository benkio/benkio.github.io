module Music exposing (Note, a440, allNames, allNotes, augmentedChord, chordToIntervals, diminishedChord, majorChord, majorScale, minorChord, note, noteToString, scaleToIntervals, triadChords)

import List exposing (concat, map)
import List.Extra exposing (unique)
import String exposing (fromFloat, fromInt, left, length)


type alias Note =
    { midiNumber : Int, frequency : Float, name : String }


type Scale
    = MajorScale { intervals : List ( Int, Int ) }


type Chord
    = MajorTriad { intervals : List ( Int, Int ) }
    | MinorTriad { intervals : List ( Int, Int ) }
    | AugmentedTriad { intervals : List ( Int, Int ) }
    | DimishedTriad { intervals : List ( Int, Int ) }


a440 : Note
a440 =
    { midiNumber = 69, frequency = 440, name = "A" }


majorScale : Scale
majorScale =
    MajorScale { intervals = [ ( 1, 2 ), ( 2, 2 ), ( 3, 1 ), ( 4, 2 ), ( 5, 2 ), ( 6, 2 ) ] }


majorChord : Chord
majorChord =
    MajorTriad { intervals = [ ( 2, 4 ), ( 4, 3 ) ] }


minorChord : Chord
minorChord =
    MinorTriad { intervals = [ ( 2, 3 ), ( 4, 4 ) ] }


diminishedChord : Chord
diminishedChord =
    DimishedTriad { intervals = [ ( 2, 3 ), ( 4, 3 ) ] }


augmentedChord : Chord
augmentedChord =
    AugmentedTriad { intervals = [ ( 2, 4 ), ( 4, 4 ) ] }


triadChords : List Chord
triadChords =
    [ majorChord
    , minorChord
    , diminishedChord
    , augmentedChord
    ]


scaleToIntervals : Scale -> List ( Int, Int )
scaleToIntervals scale =
    case scale of
        MajorScale { intervals } ->
            intervals


chordToIntervals : Chord -> List ( Int, Int )
chordToIntervals chord =
    case chord of
        MajorTriad { intervals } ->
            intervals

        MinorTriad { intervals } ->
            intervals

        AugmentedTriad { intervals } ->
            intervals

        DimishedTriad { intervals } ->
            intervals


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


allNames : List String
allNames =
    (unique << map (\n -> left 1 n.name)) allNotes


noteToString : Note -> String
noteToString n =
    n.name ++ " - " ++ fromInt n.midiNumber ++ " - " ++ fromFloat n.frequency
