module Filter exposing (Filter(..), OutputType(..), generator)


import List as L exposing (append, drop, filter, foldl, head, indexedMap, map, map2, member, tail)
import List.Extra exposing (dropWhile, dropWhileRight, find, scanl, unique, uniqueBy)
import Maybe exposing (withDefault)
import Maybe.Extra exposing (isJust, orElse)
import Music exposing (Note, Music(..), a440, allNames, allNotes, noteToString, scaleToIntervals, majorScale, triadChords, majorChord, chordToIntervals, musicToNotes)
import Random as R exposing (Generator, andThen, constant, weighted, map, int)
import Random.List exposing (choose)
import String exposing (left, length)
import Tuple exposing (first, pair, second)

type Filter
    = ChromaticScale
    | ByNoteTonality Note

type OutputType = Triad | Tetrad | SingleNote

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

generator : Filter -> OutputType -> R.Generator Music
generator filter outputType = case outputType of
                                  Triad -> triadGenerator filter
                                  Tetrad -> tetradGenerator filter
                                  SingleNote -> noteGenerator filter


triadGenerator : Filter -> R.Generator Music
triadGenerator filter =
    case filter of
        ChromaticScale -> let chordGenerator = choose triadChords |> R.map (\x -> withDefault majorChord (first x))
                          in R.map2 (\notes chord ->
                                         let note = notes |> musicToNotes |> head >> withDefault a440
                                             chordWithRoot = chord <| note
                                         in computeByIntervals note (chordToIntervals chordWithRoot) |> chordWithRoot) chromaticNoteGenerator chordGenerator
        ByNoteTonality note -> Debug.todo "Implement the random generator for the triad chord by tonality"

tetradGenerator : Filter -> R.Generator Music
tetradGenerator filter = Debug.todo "Implement the random generator for the tetrad chord"

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
                allNotes)
        |> R.map Melody
