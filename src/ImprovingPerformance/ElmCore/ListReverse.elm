module ImprovingPerformance.ElmCore.ListReverse exposing (main)

{-| Changing `List.reverse` to use JS-iteration and partial construction like List.map in `elm-optimize-level-2`.

Please note that you need to manually change the JS code for this benchmark to work.

Results: This implementation seems worse (at least when run with `elm-optimize-level-2`). Seems like `foldl` is really
fast already!

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Implementation to be replaced manually by:

```js
var $author$project$ImprovingPerformance$ElmCore$ListReverse$reverseNew = function (xs) {
  var list = _List_Nil;
  for (; xs.b; xs = xs.b) {
    list = _List_Cons(xs.a, list);
  }
  return list;
};
```

-}
reverseNew : List a -> List a
reverseNew xs =
    List.reverse xs


suite : Benchmark
suite =
    let
        tenElements : List Int
        tenElements =
            List.range 1 10

        thousandElements : List Int
        thousandElements =
            List.range 1 1000
    in
    describe "List.reverse"
        [ Benchmark.compare "10 elements"
            "Original"
            (\() -> List.reverse tenElements)
            "With JS-for"
            (\() -> reverseNew tenElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> List.reverse thousandElements)
            "With JS-for"
            (\() -> reverseNew thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
