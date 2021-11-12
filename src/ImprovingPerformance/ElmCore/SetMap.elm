module ImprovingPerformance.ElmCore.SetMap exposing (main)

{-| Changing `Set.map` to avoid an intermediate list representation.

Results: Quite a bit faster. Note that when all benchmarks are run together, the results somewhat seem worse,
that's why I've saved the results of individual benchmark runs. To be tested further.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Set exposing (Set)


{-| Original version:

    map : (comparable -> comparable2) -> Set comparable -> Set comparable2
    map func set =
        fromList (foldl (\x xs -> func x :: xs) [] set)

-}
altSetMap : (comparable -> comparable2) -> Set comparable -> Set comparable2
altSetMap func set =
    Set.foldl (\x acc -> Set.insert (func x) acc) Set.empty set


suite : Benchmark
suite =
    let
        tenElements : Set Int
        tenElements =
            List.range 1 10 |> Set.fromList

        thousandElements : Set Int
        thousandElements =
            List.range 1 1000 |> Set.fromList
    in
    describe "Set.map"
        [ Benchmark.compare "Empty dicts"
            "Original"
            (\() -> Set.map increment Set.empty)
            "Using Set.insert"
            (\() -> altSetMap increment Set.empty)
        , Benchmark.compare "10 elements"
            "Original"
            (\() -> Set.map increment tenElements)
            "Using Set.insert"
            (\() -> altSetMap increment tenElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> Set.map increment thousandElements)
            "Using Set.insert"
            (\() -> altSetMap increment thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
