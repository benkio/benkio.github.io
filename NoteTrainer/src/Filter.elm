module Filter exposing (..)--(Filter(..), noteGenerator, majorScale)

import Random exposing (Generator, weighted)
import Note exposing (Note, a440, allNotes, allNames)
import Maybe exposing (withDefault, andThen)
import List exposing (drop, map, head, foldl, tail, append)
import String exposing (length, left)
import Tuple exposing (first, second)
import List.Extra exposing (dropWhile, dropWhileRight)

type Filter
    = ChromaticScale
    | ByNoteTonality Note

type alias Scale = List Int -- List of semitones: 2 - Tone, 1 - Semitones

majorScaleIntervals : Scale
majorScaleIntervals = [2, 2, 1, 2, 2, 2]

majorScale : Note -> List Note
majorScale n =
    let octave = allNotes ++ allNotes |> (dropWhileRight ((/=) n) << dropWhile ((/=) n))
    in foldl selectNextNote ([], octave) majorScaleIntervals |> (\x -> first x ++ [withDefault a440 ((head << second) x)])

selectNextNote : Int -> (List Note, List Note) -> (List Note, List Note)
selectNextNote interval (result, octave) =
    let
        lastNote = (withDefault a440 << head) octave
        targetMidiNumber = if (lastNote.midiNumber + interval) > 80 then 68 + modBy 80 (lastNote.midiNumber + interval) else lastNote.midiNumber + interval
        nextNoteNamePrefix = allNames ++ allNames |> dropWhile (\x -> x /= left 1 lastNote.name) |> tail |> andThen head |> withDefault "A"
        newOctave = (dropWhile (\n -> n.midiNumber /= targetMidiNumber || left 1 n.name /= nextNoteNamePrefix) << withDefault [] << tail) octave
    in (result ++ [lastNote], newOctave)

noteGenerator : Filter -> Random.Generator Note
noteGenerator filter = case filter of
                           ChromaticScale -> chromaticNoteGenerator
                           ByNoteTonality note -> chromaticNoteGenerator -- TODO: implement

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
