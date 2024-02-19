module WhatIsFaster.SetMemberOrMultipleComparisons exposing (main)

{-| This benchmark aims to figure out what is faster between multiple comparisons such as `a == x || a == y || ... || a == z` and the same done using
`set = Set.fromList [ x, y, ..., z ]` and `Set.member a set`.

This likely depends on the number of elements we need to compare to.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Set exposing (Set)


elements : List String
elements =
    [ "*"
    , "{"
    , "}"
    , "["
    , "]"
    , "?"
    , "/"
    ]


elementsAsSet : Set String
elementsAsSet =
    Set.fromList elements


comparison : String -> Bool
comparison str =
    (str == "*")
        || (str == "{")
        || (str == "}")
        || (str == "[")
        || (str == "]")
        || (str == "?")
        || (str == "/")


suite : Benchmark
suite =
    describe ("Set.member vs multiple comparisons (" ++ String.fromInt (List.length elements) ++ " elements)")
        [ Benchmark.compare "Not found"
            "Set.member"
            (\() -> Set.member "a" elementsAsSet)
            "Comparison"
            (\() -> comparison "a")
        , Benchmark.compare "Found"
            "Set.member"
            (\() -> List.map (\s -> Set.member s elementsAsSet) elements)
            "Comparison"
            (\() -> List.map (\s -> comparison s) elements)
        ]


main : BenchmarkProgram
main =
    program suite
