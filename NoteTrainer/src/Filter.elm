module Filter exposing (..)

--(Filter(..), noteGenerator, majorScale)

import List exposing (append, drop, foldl, head, map, map2, tail)
import List.Extra exposing (dropWhile, dropWhileRight, find, scanl, unique, uniqueBy)
import Maybe exposing (andThen, withDefault)
import Maybe.Extra exposing (orElse)
import Note exposing (Note, a440, allNames, allNotes, noteToString)
import Random exposing (Generator, weighted)
import String exposing (left, length)
import Tuple exposing (first, pair, second)


type Filter
    = ChromaticScale
    | ByNoteTonality Note


type alias Scale =
    List Int



-- List of semitones: 2 - Tone, 1 - Semitones


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


noteGenerator : Filter -> Random.Generator Note
noteGenerator filter =
    case filter of
        ChromaticScale ->
            chromaticNoteGenerator

        ByNoteTonality note ->
            chromaticNoteGenerator



-- TODO: implement


chromaticNoteGenerator : Random.Generator Note
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
