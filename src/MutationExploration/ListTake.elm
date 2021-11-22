module MutationExploration.ListTake exposing (main)

{-| This benchmark aims to answer whether the question whether it would be worth looking into opportunistic mutation,
as explored by the Roc programming language.

Please note that you need to manually change the JS code for this benchmark to work.

Results: It's a lot faster!

Related benchmarks: MutationExploration.ListFilter

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Implementation to be replaced manually by:

```js
var $author$project$MutationExploration$ListTake$mutatingListTake = F2(
    function (n, list) {
        if (n <= 0 || !list.b) return _List_Nil;
        var end = list.b;
        while (--n > 0 && end.b) {
          end = end.b
        }
        end.b = _List_Nil;
        return list;
    });
```

-}
mutatingListTake : Int -> List a -> List a
mutatingListTake =
    List.take


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
    describe "List.take vs mutating take function"
        [ Benchmark.compare "On empty list"
            "elm/core List.take"
            (\() -> List.take 5 [])
            "mutating take"
            (\() -> mutatingListTake 5 [])
        , Benchmark.compare "Taking 5 out of 10 items"
            "elm/core List.take"
            (\() -> List.take 5 tenItems)
            "mutating take"
            (\() -> mutatingListTake 5 tenItems)
        , Benchmark.compare "Taking 500 out of 1000 items"
            "elm/core List.take"
            (\() -> List.take 500 thousandItems)
            "mutating take"
            (\() -> mutatingListTake 500 thousandItems)
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
