module Note exposing (Note, noteGenerator, noteToString)

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
