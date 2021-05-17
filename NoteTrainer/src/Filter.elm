module Filter exposing (Filter(..), OutputType(..), generator)

import Dict exposing (Dict, get)
import List as L exposing (append, drop, filter, foldl, head, indexedMap, map, map2, member, tail)
import List.Extra exposing (dropWhile, dropWhileRight, find, scanl, unique, uniqueBy)
import Maybe exposing (withDefault)
import Maybe.Extra exposing (isJust, orElse)
import Music exposing (..)
import Random as R exposing (Generator, andThen, constant, int, map, weighted)
import Random.List exposing (choose)
import String exposing (left, length)
import Tuple exposing (first, pair, second)


type Filter
    = ChromaticScale
    | ByNoteTonality Note


type OutputType
    = Triad
    | Tetrad
    | SingleNote


computeByIntervals : Note -> List ( Int, Int ) -> List Note
computeByIntervals n degreeNInterval =
    let
        octave =
            allNotes ++ allNotes |> (uniqueBy noteToString << dropWhile ((/=) n))

        noteNames =
            allNames
                ++ allNames
                |> unique
                << dropWhile ((/=) (left 1 n.name))
                |> indexedMap Tuple.pair
                |> filter (\x -> member (first x) (0 :: L.map first degreeNInterval))
                |> L.map second

        midiNumbers =
            scanl
                (\interval prevNoteMidiNum ->
                    let
                        x =
                            interval + prevNoteMidiNum
                    in
                    if x > 80 then
                        (x - 80) + 68

                    else
                        x
                )
                n.midiNumber
                (L.map second degreeNInterval)

        targetNotes =
            map2 pair noteNames midiNumbers
    in
    L.map
        (\target ->
            find
                (\x ->
                    left 1 x.name == first target && x.midiNumber == second target
                )
                octave
                |> orElse (find (\x -> x.midiNumber == second target) octave)
                |> withDefault a440
        )
        targetNotes


computeNoteDegree : Note -> Note -> List ( Int, Int ) -> Int
computeNoteDegree rootNote targetNote degreeNInterval =
    let
        semitonesToTarget =
            if targetNote.midiNumber >= rootNote.midiNumber then
                targetNote.midiNumber - rootNote.midiNumber

            else
                ((targetNote.midiNumber - 68) + 80) - rootNote.midiNumber
    in
    foldl
        (\dis taracc ->
            if first taracc == 0 then
                taracc

            else
                ( first taracc - second dis, first dis )
        )
        ( semitonesToTarget, 0 )
        (( 0, 0 ) :: degreeNInterval)
        |> second



-- Generator --------------------------------------------------------------


generator : Filter -> OutputType -> R.Generator Music
generator filter outputType =
    case outputType of
        Triad ->
            chordGenerator filter triadChords majorChord triadMajorScaleHarmonization

        Tetrad ->
            chordGenerator filter tetradChords majorSevenChord tetradMajorScaleHarmonization

        SingleNote ->
            noteGenerator filter


chordGenerator : Filter -> List (Note -> List Note -> Chord) -> (Note -> List Note -> Chord) -> Dict Int (Note -> List Note -> Chord) -> R.Generator Music
chordGenerator filter chords defaultChord majorScaleHarmonization =
    case filter of
        ChromaticScale ->
            let
                chordGenerator1 =
                    choose chords |> R.map (first >> withDefault defaultChord)
            in
            R.map2
                (\notes chord ->
                    let
                        note =
                            notes |> musicToNotes |> head >> withDefault a440

                        chordWithRoot =
                            \ns -> chord note ns
                    in
                    computeByIntervals note ([] |> chordWithRoot |> chordToIntervals) |> chordWithRoot |> Harmony
                )
                chromaticNoteGenerator
                chordGenerator1

        ByNoteTonality note ->
            computeByIntervals note (scaleToIntervals majorScale)
                |> byNoteTonalityGenerator
                |> R.map
                    (musicToNotes
                        >> head
                        >> withDefault a440
                        >> (\n ->
                                get (computeNoteDegree note n (scaleToIntervals majorScale)) majorScaleHarmonization
                                    |> withDefault defaultChord
                                    |> (\c -> c n)
                                    |> (\chordWithRoot -> computeByIntervals n ([] |> chordWithRoot |> chordToIntervals) |> chordWithRoot |> Harmony)
                           )
                    )


noteGenerator : Filter -> R.Generator Music
noteGenerator filter =
    case filter of
        ChromaticScale ->
            chromaticNoteGenerator

        ByNoteTonality note ->
            computeByIntervals note (scaleToIntervals majorScale) |> byNoteTonalityGenerator


byNoteTonalityGenerator : List Note -> R.Generator Music
byNoteTonalityGenerator notes =
    R.andThen
        (\x ->
            let
                maybeResult =
                    first x
            in
            if isJust maybeResult then
                withDefault a440 maybeResult |> Melody |> R.constant

            else
                byNoteTonalityGenerator notes
        )
        (choose notes)


chromaticNoteGenerator : R.Generator Music
chromaticNoteGenerator =
    (weighted ( 10, a440 ) <|
        drop 1 <|
            List.map
                (\n ->
                    if length n.name == 1 then
                        ( 10, n )

                    else
                        ( 5, n )
                )
                allNotes
    )
        |> R.map Melody
