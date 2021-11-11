module ListOrderingExploration.ListMap exposing (main)

{-| This benchmark aims to showcase that there is overhead in List.map in its
goal to preserve the original order.

When you don't care about the order, then maybe consider using a map function that doesn't preserve the order.

I am getting very different results randomly (see related benchmark result screenshots).
Either the alt map is much better (+50/+100% faster) or it's SO MUCH better (+500/+600% faster),
and I can't explain why.

Related benchmarks: ListOrderingExploration.ListMapFoldVsRecursion, ListOrderingExploration.ListMapChained

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


altMap : (a -> b) -> List a -> List b
altMap mapper list =
    fold mapper list []


fold : (a -> b) -> List a -> List b -> List b
fold func list acc =
    case list of
        [] ->
            acc

        x :: xs ->
            fold func xs (func x :: acc)


suite : Benchmark
suite =
    let
        tenItems : List Int
        tenItems =
            List.range 1 10

        thousandItems : List Int
        thousandItems =
            List.range 1 1000
    in
    describe "List.map vs reversing map function"
        [ Benchmark.compare "0 items"
            "elm/core List.map"
            (\() -> List.map increment [])
            "Reversing map"
            (\() -> altMap increment [])
        , Benchmark.compare "10 items"
            "elm/core List.map"
            (\() -> List.map increment tenItems)
            "Reversing map"
            (\() -> altMap increment tenItems)
        , Benchmark.compare "1000 items"
            "elm/core List.map"
            (\() -> List.map increment thousandItems)
            "Reversing map"
            (\() -> altMap increment thousandItems)
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
