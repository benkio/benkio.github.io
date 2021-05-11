module Music exposing (..)

import Dict exposing (Dict, fromList)
import List exposing (concat, map)
import List.Extra exposing (unique)
import String exposing (fromFloat, fromInt, left, length)


type alias Note =
    { midiNumber : Int, frequency : Float, name : String }


type Scale
    = MajorScale { intervals : List ( Int, Int ) }


type Chord
    = Major { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | MajorSeven { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | MajorMinorSeven { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | Minor { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | MinorSeven { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | MinorMajorSeven { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | Augmented { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | AugmentedSeven { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | Dimished { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | DimishedSeven { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | HalfDimishedSeven { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }


type Music
    = Melody Note
    | Harmony Chord


a440 : Note
a440 =
    { midiNumber = 69, frequency = 440, name = "A" }


majorScale : Scale
majorScale =
    MajorScale { intervals = [ ( 1, 2 ), ( 2, 2 ), ( 3, 1 ), ( 4, 2 ), ( 5, 2 ), ( 6, 2 ) ] }


triadMajorScaleHarmonization : Dict Int (Note -> List Note -> Chord)
triadMajorScaleHarmonization =
    fromList
        [ ( 0, majorChord )
        , ( 1, minorChord )
        , ( 2, minorChord )
        , ( 3, majorChord )
        , ( 4, majorChord )
        , ( 5, minorChord )
        , ( 6, diminishedChord )
        ]


tetradMajorScaleHarmonization : Dict Int (Note -> List Note -> Chord)
tetradMajorScaleHarmonization =
    fromList
        [ ( 0, majorSevenChord )
        , ( 1, minorSevenChord )
        , ( 2, minorSevenChord )
        , ( 3, majorSevenChord )
        , ( 4, majorMinorSevenChord )
        , ( 5, minorSevenChord )
        , ( 6, halfDiminishedSevenChord )
        ]


majorChord : Note -> List Note -> Chord
majorChord n ns =
    Major { intervals = [ ( 2, 4 ), ( 4, 3 ) ], rootNote = n, notes = ns }


majorSevenChord : Note -> List Note -> Chord
majorSevenChord n ns =
    MajorSeven { intervals = [ ( 2, 4 ), ( 4, 3 ), ( 6, 4 ) ], rootNote = n, notes = ns }


majorMinorSevenChord : Note -> List Note -> Chord
majorMinorSevenChord n ns =
    Major { intervals = [ ( 2, 4 ), ( 4, 3 ), ( 6, 3 ) ], rootNote = n, notes = ns }


minorChord : Note -> List Note -> Chord
minorChord n ns =
    Minor { intervals = [ ( 2, 3 ), ( 4, 4 ) ], rootNote = n, notes = ns }


minorSevenChord : Note -> List Note -> Chord
minorSevenChord n ns =
    MinorSeven { intervals = [ ( 2, 3 ), ( 4, 4 ), ( 6, 3 ) ], rootNote = n, notes = ns }


minorMajorSevenChord : Note -> List Note -> Chord
minorMajorSevenChord n ns =
    MinorMajorSeven { intervals = [ ( 2, 3 ), ( 4, 4 ), ( 6, 4 ) ], rootNote = n, notes = ns }


augmentedChord : Note -> List Note -> Chord
augmentedChord n ns =
    Augmented { intervals = [ ( 2, 4 ), ( 4, 4 ) ], rootNote = n, notes = ns }


augmentedSevenChord : Note -> List Note -> Chord
augmentedSevenChord n ns =
    AugmentedSeven { intervals = [ ( 2, 4 ), ( 4, 4 ), ( 6, 2 ) ], rootNote = n, notes = ns }


diminishedChord : Note -> List Note -> Chord
diminishedChord n ns =
    Dimished { intervals = [ ( 2, 3 ), ( 4, 3 ) ], rootNote = n, notes = ns }


diminishedSevenChord : Note -> List Note -> Chord
diminishedSevenChord n ns =
    DimishedSeven { intervals = [ ( 2, 3 ), ( 4, 3 ), ( 6, 3 ) ], rootNote = n, notes = ns }


halfDiminishedSevenChord : Note -> List Note -> Chord
halfDiminishedSevenChord n ns =
    HalfDimishedSeven { intervals = [ ( 2, 3 ), ( 4, 3 ), ( 6, 4 ) ], rootNote = n, notes = ns }


triadChords : List (Note -> List Note -> Chord)
triadChords =
    [ majorChord
    , minorChord
    , diminishedChord
    , augmentedChord
    ]


tetradChords : List (Note -> List Note -> Chord)
tetradChords =
    [ majorSevenChord
    , majorMinorSevenChord
    , minorSevenChord
    , minorMajorSevenChord
    , augmentedSevenChord
    , diminishedSevenChord
    , halfDiminishedSevenChord
    ]


scaleToIntervals : Scale -> List ( Int, Int )
scaleToIntervals scale =
    case scale of
        MajorScale { intervals } ->
            intervals


chordToIntervals : Chord -> List ( Int, Int )
chordToIntervals chord =
    case chord of
        Major { intervals } ->
            intervals

        MajorSeven { intervals } ->
            intervals

        MajorMinorSeven { intervals } ->
            intervals

        Minor { intervals } ->
            intervals

        MinorSeven { intervals } ->
            intervals

        MinorMajorSeven { intervals } ->
            intervals

        Augmented { intervals } ->
            intervals

        AugmentedSeven { intervals } ->
            intervals

        Dimished { intervals } ->
            intervals

        DimishedSeven { intervals } ->
            intervals

        HalfDimishedSeven { intervals } ->
            intervals


mkNote : Int -> List Note
mkNote midiNumber =
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
        [ mkNote 69
        , mkNote 70
        , mkNote 71
        , mkNote 72
        , mkNote 73
        , mkNote 74
        , mkNote 75
        , mkNote 76
        , mkNote 77
        , mkNote 78
        , mkNote 79
        , mkNote 80
        ]


allNames : List String
allNames =
    (unique << map (\n -> left 1 n.name)) allNotes


noteToString : Note -> String
noteToString n =
    n.name ++ " - " ++ fromInt n.midiNumber ++ " - " ++ fromFloat n.frequency


chordToString : Chord -> ( String, String )
chordToString chord =
    case chord of
        Major { rootNote } ->
            ( rootNote.name, "" )

        MajorSeven { rootNote } ->
            ( rootNote.name, "M7" )

        MajorMinorSeven { rootNote } ->
            ( rootNote.name, "7" )

        Minor { rootNote } ->
            ( rootNote.name, "min" )

        MinorSeven { rootNote } ->
            ( rootNote.name, "m7" )

        MinorMajorSeven { rootNote } ->
            ( rootNote.name, "mΔ7" )

        Augmented { rootNote } ->
            ( rootNote.name, "#5" )

        AugmentedSeven { rootNote } ->
            ( rootNote.name, "M7#5" )

        Dimished { rootNote } ->
            ( rootNote.name, "dim" )

        DimishedSeven { rootNote } ->
            ( rootNote.name, "o7" )

        HalfDimishedSeven { rootNote } ->
            ( rootNote.name, "m7b5" )


chordToNotes : Chord -> List Note
chordToNotes chord =
    case chord of
        Major { notes } ->
            notes

        MajorSeven { notes } ->
            notes

        MajorMinorSeven { notes } ->
            notes

        Minor { notes } ->
            notes

        MinorSeven { notes } ->
            notes

        MinorMajorSeven { notes } ->
            notes

        Augmented { notes } ->
            notes

        AugmentedSeven { notes } ->
            notes

        Dimished { notes } ->
            notes

        DimishedSeven { notes } ->
            notes

        HalfDimishedSeven { notes } ->
            notes


musicToNotes : Music -> List Note
musicToNotes music =
    case music of
        Melody note ->
            [ note ]

        Harmony chord ->
            chordToNotes chord
