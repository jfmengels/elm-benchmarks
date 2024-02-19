module WhatIsFaster.CaseOfOrMultipleComparisons exposing (main)

{-| This benchmark aims to figure out what is faster between multiple comparisons such as `a == x || a == y || ... || a == z` and the same done using
a case expression.

This likely depends on the number of elements we need to compare to.

Related benchmarks: WhatIsFaster.SetMemberOrMultipleComparisons

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


comparison : String -> Bool
comparison str =
    (str == "*")
        || (str == "{")
        || (str == "}")
        || (str == "[")
        || (str == "]")
        || (str == "?")
        || (str == "/")


caseOf : String -> Bool
caseOf str =
    case str of
        "*" ->
            True

        "{" ->
            True

        "}" ->
            True

        "[" ->
            True

        "]" ->
            True

        "?" ->
            True

        "/" ->
            True

        _ ->
            False


suite : Benchmark
suite =
    describe "case of vs multiple comparisons"
        [ Benchmark.compare "Not found"
            "Case of"
            (\() -> caseOf "a")
            "Comparison"
            (\() -> comparison "a")
        , Benchmark.compare "Found"
            "Case of"
            (\() -> List.map caseOf elements)
            "Comparison"
            (\() -> List.map comparison elements)
        ]


main : BenchmarkProgram
main =
    program suite
