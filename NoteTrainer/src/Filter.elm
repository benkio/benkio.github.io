module Filter exposing (Filter(..))

import Note exposing (Note(..), noteToString)
import List.Extra exposing (dropWhile)

type Filter
    = ChromaticScale
    | ByNoteTonality Note

-- toFilterFunction : Filter -> (List Note -> List Note)
-- toFilterFunction filter = case filter of
--                               ChromaticScale -> identity
--                               ByNoteTonality n -> noteTonality n

-- noteTonality : Note -> List Note
-- noteTonality n =
