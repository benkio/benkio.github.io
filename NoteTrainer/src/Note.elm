module Note exposing (Note(..), noteGenerator, noteToFrequency, noteToString)

import Random exposing (Generator, weighted)

type Note
    = A
    | As
    | Bb
    | B
    | C
    | Cs
    | Db
    | D
    | Ds
    | Eb
    | E
    | F
    | Fs
    | Gb
    | G
    | Gs
    | Ab

noteToString : Note -> String
noteToString note = case note of
                        A  -> "A"
                        As -> "A#"
                        Bb -> "Bb"
                        B  -> "B"
                        C  -> "C"
                        Cs -> "C#"
                        Db -> "Db"
                        D  -> "D"
                        Ds -> "D#"
                        Eb -> "Eb"
                        E  -> "E"
                        F  -> "F"
                        Fs -> "F#"
                        Gb -> "Gb"
                        G  -> "G"
                        Gs -> "G#"
                        Ab -> "Ab"

noteToFrequency : Note -> Float
noteToFrequency note = case note of
                        A  -> 440.00
                        As -> 466.16
                        Bb -> 466.16
                        B  -> 493.88
                        C  -> 523.25
                        Cs -> 554.37
                        Db -> 554.37
                        D  -> 587.33
                        Ds -> 622.25
                        Eb -> 622.25
                        E  -> 659.25
                        F  -> 698.46
                        Fs -> 739.99
                        Gb -> 739.99
                        G  -> 783.99
                        Gs -> 830.61
                        Ab -> 830.61

noteGenerator : Random.Generator Note
noteGenerator =
    weighted ( 10, A )
        [ ( 5, As )
        , ( 5, Bb )
        , ( 10, B )
        , ( 10, C )
        , ( 5, Cs )
        , ( 5, Db )
        , ( 10, D )
        , ( 5, Ds )
        , ( 5, Eb )
        , ( 10, E )
        , ( 10, F )
        , ( 5, Fs )
        , ( 5, Gb )
        , ( 10, G )
        , ( 5, Gs )
        , ( 5, Ab )
        ]
