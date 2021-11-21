module NativeJsArrayExploration.DictFromLiteral exposing (main)

{-| This benchmarks aims to show whether skipping the `_List_fromArray` call on `Dict.fromList`
when it is used on literals improves the performance.

Please note that you need to manually change the JS code for this benchmark to work.

To run this benchmark, inject the following function, and then replace the two benchmarks below.

```js
var _nativeDictFromList = function (arr) {
    var out = $elm$core$Dict$empty;
    for (var i = 0; i < arr.length; i++) {
        out = A3($elm$core$Dict$insert, arr[i].a, arr[i].b, out);
    }
    return out;
};
```

Results: It's faster by a noticeable margin. We can probably do better by removing the A3 wrapping.

Related benchmarks: NativeJsArrayExploration.DictFromLiteral

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Dict


suite : Benchmark
suite =
    describe "Dict.fromList on list literals"
        [ Benchmark.compare "10 items"
            "elm/core Dict.fromList"
            (\() -> Dict.fromList [ ( 1, 1 ), ( 2, 2 ), ( 3, 3 ), ( 4, 4 ), ( 5, 5 ), ( 6, 6 ), ( 7, 7 ), ( 8, 8 ), ( 9, 9 ), ( 10, 10 ) ])
            "With special handling"
            {- And the snippet above and replace this benchmark suite by
               ```js
               function (_v1) {
                  return _nativeDictFromList(
                          [
                              _Utils_Tuple2(1, 1),
                              -- ...
                      ]);
               }),
               ```
            -}
            (\() -> Dict.fromList [ ( 1, 1 ), ( 2, 2 ), ( 3, 3 ), ( 4, 4 ), ( 5, 5 ), ( 6, 6 ), ( 7, 7 ), ( 8, 8 ), ( 9, 9 ), ( 10, 10 ) ])
        , Benchmark.compare "100 items"
            "elm/core Dict.fromList"
            (\() -> Dict.fromList [ ( 1, 1 ), ( 2, 2 ), ( 3, 3 ), ( 4, 4 ), ( 5, 5 ), ( 6, 6 ), ( 7, 7 ), ( 8, 8 ), ( 9, 9 ), ( 10, 10 ), ( 11, 11 ), ( 12, 12 ), ( 13, 13 ), ( 14, 14 ), ( 15, 15 ), ( 16, 16 ), ( 17, 17 ), ( 18, 18 ), ( 19, 19 ), ( 20, 20 ), ( 21, 21 ), ( 22, 22 ), ( 23, 23 ), ( 24, 24 ), ( 25, 25 ), ( 26, 26 ), ( 27, 27 ), ( 28, 28 ), ( 29, 29 ), ( 30, 30 ), ( 31, 31 ), ( 32, 32 ), ( 33, 33 ), ( 34, 34 ), ( 35, 35 ), ( 36, 36 ), ( 37, 37 ), ( 38, 38 ), ( 39, 39 ), ( 40, 40 ), ( 41, 41 ), ( 42, 42 ), ( 43, 43 ), ( 44, 44 ), ( 45, 45 ), ( 46, 46 ), ( 47, 47 ), ( 48, 48 ), ( 49, 49 ), ( 50, 50 ), ( 51, 51 ), ( 52, 52 ), ( 53, 53 ), ( 54, 54 ), ( 55, 55 ), ( 56, 56 ), ( 57, 57 ), ( 58, 58 ), ( 59, 59 ), ( 60, 60 ), ( 61, 61 ), ( 62, 62 ), ( 63, 63 ), ( 64, 64 ), ( 65, 65 ), ( 66, 66 ), ( 67, 67 ), ( 68, 68 ), ( 69, 69 ), ( 70, 70 ), ( 71, 71 ), ( 72, 72 ), ( 73, 73 ), ( 74, 74 ), ( 75, 75 ), ( 76, 76 ), ( 77, 77 ), ( 78, 78 ), ( 79, 79 ), ( 80, 80 ), ( 81, 81 ), ( 82, 82 ), ( 83, 83 ), ( 84, 84 ), ( 85, 85 ), ( 86, 86 ), ( 87, 87 ), ( 88, 88 ), ( 89, 89 ), ( 90, 90 ), ( 91, 91 ), ( 92, 92 ), ( 93, 93 ), ( 94, 94 ), ( 95, 95 ), ( 96, 96 ), ( 97, 97 ), ( 98, 98 ), ( 99, 99 ), ( 100, 100 ) ])
            "With special handling"
            {- Replace by
               ```js
               function (_v3) {
                  return _nativeDictFromList(
                          [
                              _Utils_Tuple2(1, 1),
                              -- ...
                      ]);
               }),
               ```
            -}
            (\() -> Dict.fromList [ ( 1, 1 ), ( 2, 2 ), ( 3, 3 ), ( 4, 4 ), ( 5, 5 ), ( 6, 6 ), ( 7, 7 ), ( 8, 8 ), ( 9, 9 ), ( 10, 10 ), ( 11, 11 ), ( 12, 12 ), ( 13, 13 ), ( 14, 14 ), ( 15, 15 ), ( 16, 16 ), ( 17, 17 ), ( 18, 18 ), ( 19, 19 ), ( 20, 20 ), ( 21, 21 ), ( 22, 22 ), ( 23, 23 ), ( 24, 24 ), ( 25, 25 ), ( 26, 26 ), ( 27, 27 ), ( 28, 28 ), ( 29, 29 ), ( 30, 30 ), ( 31, 31 ), ( 32, 32 ), ( 33, 33 ), ( 34, 34 ), ( 35, 35 ), ( 36, 36 ), ( 37, 37 ), ( 38, 38 ), ( 39, 39 ), ( 40, 40 ), ( 41, 41 ), ( 42, 42 ), ( 43, 43 ), ( 44, 44 ), ( 45, 45 ), ( 46, 46 ), ( 47, 47 ), ( 48, 48 ), ( 49, 49 ), ( 50, 50 ), ( 51, 51 ), ( 52, 52 ), ( 53, 53 ), ( 54, 54 ), ( 55, 55 ), ( 56, 56 ), ( 57, 57 ), ( 58, 58 ), ( 59, 59 ), ( 60, 60 ), ( 61, 61 ), ( 62, 62 ), ( 63, 63 ), ( 64, 64 ), ( 65, 65 ), ( 66, 66 ), ( 67, 67 ), ( 68, 68 ), ( 69, 69 ), ( 70, 70 ), ( 71, 71 ), ( 72, 72 ), ( 73, 73 ), ( 74, 74 ), ( 75, 75 ), ( 76, 76 ), ( 77, 77 ), ( 78, 78 ), ( 79, 79 ), ( 80, 80 ), ( 81, 81 ), ( 82, 82 ), ( 83, 83 ), ( 84, 84 ), ( 85, 85 ), ( 86, 86 ), ( 87, 87 ), ( 88, 88 ), ( 89, 89 ), ( 90, 90 ), ( 91, 91 ), ( 92, 92 ), ( 93, 93 ), ( 94, 94 ), ( 95, 95 ), ( 96, 96 ), ( 97, 97 ), ( 98, 98 ), ( 99, 99 ), ( 100, 100 ) ])
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
