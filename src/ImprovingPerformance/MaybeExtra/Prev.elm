module ImprovingPerformance.MaybeExtra.Prev exposing (main)

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


prev : Maybe a -> Maybe b -> Maybe a
prev =
    Maybe.map2 always


prevNew : Maybe a -> Maybe b -> Maybe a
prevNew a b =
    case b of
        Nothing ->
            Nothing

        Just _ ->
            a


suite : Benchmark
suite =
    let
        just : Maybe number
        just =
            Just 1
    in
    Benchmark.compare "Maybe.Extra.prev"
        "Using map2"
        (\() -> [ prev Nothing Nothing, prev just Nothing, prev Nothing just, prev just just ])
        "Using pattern matching"
        (\() -> [ prevNew Nothing Nothing, prevNew just Nothing, prevNew Nothing just, prevNew just just ])


main : BenchmarkProgram
main =
    program suite
