module Music exposing (..)

import List exposing (concat, map)
import List.Extra exposing (unique)
import String exposing (fromFloat, fromInt, left, length)
import Dict exposing (Dict, fromList)

type alias Note =
    { midiNumber : Int, frequency : Float, name : String }


type Scale
    = MajorScale { intervals : List ( Int, Int ) }


type Chord
    = MajorTriad { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | MinorTriad { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | AugmentedTriad { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }
    | DimishedTriad { intervals : List ( Int, Int ), rootNote : Note, notes : List Note }


type Music
    = Melody Note
    | Harmony Chord


a440 : Note
a440 =
    { midiNumber = 69, frequency = 440, name = "A" }


majorScale : Scale
majorScale =
    MajorScale { intervals = [ ( 1, 2 ), ( 2, 2 ), ( 3, 1 ), ( 4, 2 ), ( 5, 2 ), ( 6, 2 ) ] }

majorScaleHarmonization : Dict Int (Note -> List Note -> Chord)
majorScaleHarmonization = fromList [
                           (0, majorChord)
                          , (1, minorChord)
                          , (2, minorChord)
                          , (3, majorChord)
                          , (4, majorChord)
                          , (5, minorChord)
                          , (6, diminishedChord)
                          ]

majorChord : Note -> List Note -> Chord
majorChord n ns =
    MajorTriad { intervals = [ ( 2, 4 ), ( 4, 3 ) ], rootNote = n, notes = ns }


minorChord : Note -> List Note -> Chord
minorChord n ns =
    MinorTriad { intervals = [ ( 2, 3 ), ( 4, 4 ) ], rootNote = n, notes = ns }


diminishedChord : Note -> List Note -> Chord
diminishedChord n ns =
    DimishedTriad { intervals = [ ( 2, 3 ), ( 4, 3 ) ], rootNote = n, notes = ns }


augmentedChord : Note -> List Note -> Chord
augmentedChord n ns =
    AugmentedTriad { intervals = [ ( 2, 4 ), ( 4, 4 ) ], rootNote = n, notes = ns }


triadChords : List (Note -> List Note -> Chord)
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
        MajorTriad { rootNote } ->
            ( rootNote.name, "" )

        MinorTriad { rootNote } ->
            ( rootNote.name, "min" )

        AugmentedTriad { rootNote } ->
            ( rootNote.name, "aug" )

        DimishedTriad { rootNote } ->
            ( rootNote.name, "dim" )


chordToNotes : Chord -> List Note
chordToNotes chord =
    case chord of
        MajorTriad { notes } ->
            notes

        MinorTriad { notes } ->
            notes

        AugmentedTriad { notes } ->
            notes

        DimishedTriad { notes } ->
            notes


musicToNotes : Music -> List Note
musicToNotes music =
    case music of
        Melody note ->
            [ note ]

        Harmony chord ->
            chordToNotes chord
