module Filter exposing (Filter(..), noteGenerator)


import List exposing (append, drop, filter, foldl, head, indexedMap, map, map2, member, tail)
import List.Extra exposing (dropWhile, dropWhileRight, find, scanl, unique, uniqueBy)
import Maybe exposing (withDefault)
import Maybe.Extra exposing (isJust, orElse)
import Music exposing (Note, a440, allNames, allNotes, noteToString)
import Random as R exposing (Generator, andThen, constant, weighted)
import Random.List exposing (choose)
import String exposing (left, length)
import Tuple exposing (first, pair, second)


type Filter
    = ChromaticScale
    | ByNoteTonality Note


majorScaleIntervals : List ( Int, Int )
majorScaleIntervals =
    [ ( 1, 2 ), ( 2, 2 ), ( 3, 1 ), ( 4, 2 ), ( 5, 2 ), ( 6, 2 ) ]


majorChord : List ( Int, Int )
majorChord =
    [ ( 2, 4 ), ( 4, 3 ) ]


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
                |> filter (\x -> member (first x) (0 :: map first degreeNInterval))
                |> map second

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
                (map second degreeNInterval)

        targetNotes =
            map2 pair noteNames midiNumbers
    in
    map
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


noteGenerator : Filter -> R.Generator Note
noteGenerator filter =
    case filter of
        ChromaticScale ->
            chromaticNoteGenerator

        ByNoteTonality note ->
            computeByIntervals note majorScaleIntervals |> byNoteTonalityGenerator


byNoteTonalityGenerator : List Note -> R.Generator Note
byNoteTonalityGenerator notes =
    R.andThen
        (\x ->
            let
                maybeResult =
                    first x
            in
            if isJust maybeResult then
                withDefault a440 maybeResult |> constant

            else
                byNoteTonalityGenerator notes
        )
        (choose notes)


chromaticNoteGenerator : R.Generator Note
chromaticNoteGenerator =
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
