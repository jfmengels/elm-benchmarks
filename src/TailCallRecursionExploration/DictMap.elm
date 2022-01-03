module TailCallRecursionExploration.DictMap exposing (main)

{-| Comparing the performance difference between the native Dict.map and one using partial tail call recursion modulo cons.

Please note that you need to manually change the JS code for this benchmark to work.

Result: Having two recursive calls is somewhat faster than one recursive call plus a loop continuation.
I don't understand why though.

-}

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Dict exposing (Dict)


{-| Implementation to be replaced manually by:

```js
var $author$project$TailCallRecursionExploration$DictMap$tcoMap = F2(function (func, dict) {
    var $start = { d: null };
    var $end = $start;
    map: while (true) {
        if (dict.$ === -2) {
            $end.d = $elm$core$Dict$RBEmpty_elm_builtin;
            return $start.d;
        }
        else {
            var color = dict.a;
            var key = dict.b;
            var value = dict.c;
            var left = dict.d;
            var right = dict.e;
            $end.d = A5(
                $elm$core$Dict$RBNode_elm_builtin,
                color,
                key,
                A2(func, key, value),
                null,
                A2($author$project$TailCallRecursionExploration$DictMap$tcoMap, func, right)
            );
            $end = $end.d;
            dict = left;
            continue map;
        }
    }
});
```

-}
tcoMap : (k -> a -> b) -> Dict.Dict k a -> Dict.Dict k b
tcoMap =
    Dict.map


suite : Benchmark
suite =
    let
        thousandItems : Dict Int Int
        thousandItems =
            List.range 1 1000
                |> List.map (\key -> ( key, key ))
                |> Dict.fromList
    in
    Benchmark.compare "Dict.map"
        "Native"
        (\() -> Dict.map increment thousandItems)
        "Dict.map with recursion"
        (\() -> tcoMap increment thousandItems)


main : BenchmarkProgram
main =
    program suite


increment : a -> Int -> Int
increment _ int =
    int + 1
