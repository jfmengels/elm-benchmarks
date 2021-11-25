module MutationExploration.ListFilter exposing (main)

{-| This benchmark aims to answer whether the question whether it would be worth looking into opportunistic mutation,
as explored by the Roc programming language.

Please note that you need to manually change the JS code for this benchmark to work.

Results: It's a lot faster!

Note that the benchmark is very likely downplaying the results, because they include the creation of new lists
(otherwise we'd be working on already filtered lists in the benchmarks, which would also be bad).

Related benchmarks: MutationExploration.ListMap

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Implementation to be replaced manually by:

```js
var $author$project$MutationExploration$ListFilter$mutatingListFilter = F2(
    function (isGood, list) {
        // Find the start of the list
        var start;
        for (var xs = list; !start && xs.b; xs = xs.b)
        {
            if (isGood(xs.a)) {
                start = xs;
            }
        }
        if (!start) {
            return _List_Nil;
        }
        // Remove the items that don't match from the rest of the list
        var previous = start;
        for (var xs = previous.b; xs.b; xs = xs.b)
        {
            if (isGood(xs.a)) {
                previous = previous.b = xs;
            }
        }
        return start;
    });
```

-}
mutatingListFilter : (a -> Bool) -> List a -> List a
mutatingListFilter =
    List.filter


suite : Benchmark
suite =
    describe "List.filter vs mutating filter function"
        [ Benchmark.compare "0 items"
            "elm/core List.filter"
            (\() -> List.filter isDivisibleBy2 [])
            "mutating filter"
            (\() -> mutatingListFilter isDivisibleBy2 [])
        , Benchmark.compare "10 items"
            "elm/core List.filter"
            (\() -> List.filter isDivisibleBy2 (List.range 1 10))
            "mutating filter"
            (\() -> mutatingListFilter isDivisibleBy2 (List.range 1 10))
        , Benchmark.compare "1000 items"
            "elm/core List.filter"
            (\() -> List.filter isDivisibleBy2 (List.range 1 1000))
            "mutating filter"
            (\() -> mutatingListFilter isDivisibleBy2 (List.range 1 1000))
        ]


main : BenchmarkProgram
main =
    program suite


isDivisibleBy2 : Int -> Bool
isDivisibleBy2 n =
    modBy 2 n == 0
