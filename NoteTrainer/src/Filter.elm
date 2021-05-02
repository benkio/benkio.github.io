module Filter exposing (Filter(..), noteGenerator)

import List exposing (append, drop, foldl, head, map, map2, tail)
import List.Extra exposing (dropWhile, dropWhileRight, find, scanl, unique, uniqueBy)
import Maybe exposing (withDefault)
import Maybe.Extra exposing (isJust, orElse)
import Music exposing (Note, Scale,a440, allNames, allNotes, noteToString)
import Random as R exposing (Generator, andThen, constant, weighted)
import Random.List exposing (choose)
import String exposing (left, length)
import Tuple exposing (first, pair, second)


type Filter
    = ChromaticScale
    | ByNoteTonality Note


majorScaleIntervals : Scale
majorScaleIntervals =
    [ 2, 2, 1, 2, 2, 2 ]


majorScale : Note -> List Note
majorScale n =
    let
        octave =
            allNotes ++ allNotes |> (uniqueBy noteToString << dropWhile ((/=) a440))

        noteNames =
            allNames ++ allNames |> unique << dropWhile ((/=) (left 1 n.name))

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
                majorScaleIntervals

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
            majorScale note |> byNoteTonalityGenerator


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
