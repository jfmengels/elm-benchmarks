module ImprovingPerformance.MaybeExtra.Next exposing (main)

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


next : Maybe a -> Maybe b -> Maybe b
next =
    Maybe.map2 (\b a -> always a b)


nextNew : Maybe a -> Maybe b -> Maybe b
nextNew a b =
    case a of
        Nothing ->
            Nothing

        Just _ ->
            b


suite : Benchmark
suite =
    let
        just : Maybe number
        just =
            Just 1
    in
    Benchmark.compare "Maybe.Extra.next"
        "Using map2"
        (\() -> [ next Nothing Nothing, next just Nothing, next Nothing just, next just just ])
        "Using pattern matching"
        (\() -> [ nextNew Nothing Nothing, nextNew just Nothing, nextNew Nothing just, nextNew just just ])


main : BenchmarkProgram
main =
    program suite
