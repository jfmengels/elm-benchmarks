module MutationExploration.ListMap exposing (main)

{-| This benchmark aims to answer whether the question whether it would be worth looking into opportunistic mutation,
as explored by the Roc programming language.

Please note that you need to manually change the JS code for this benchmark to work.

Results: It's a lot faster!

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Implementation to be replaced manually by:

```js
var $author$project$MutationExploration$ListMap$mutatingListMap = F2(
    function (f, list) {
        for (var xs = list; xs.b; xs = xs.b)
        {
            xs.a = f(xs.a);
        }
        return list;
    });
```

-}
mutatingListMap : (a -> b) -> List a -> List b
mutatingListMap =
    List.map


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
    describe "List.map vs mutating map function"
        [ Benchmark.compare "0 items"
            "elm/core List.map"
            (\() -> List.map increment [])
            "mutating map"
            (\() -> mutatingListMap increment [])
        , Benchmark.compare "10 items"
            "elm/core List.map"
            (\() -> List.map increment tenItems)
            "mutating map"
            (\() -> mutatingListMap increment (List.range 1 10))
        , Benchmark.compare "1000 items"
            "elm/core List.map"
            (\() -> List.map increment thousandItems)
            "mutating map"
            (\() -> mutatingListMap increment thousandItems)
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
