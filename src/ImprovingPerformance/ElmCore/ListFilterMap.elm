module ImprovingPerformance.ElmCore.ListFilterMap exposing (main)

{-| Changing `List.filterMap` to use JS-iteration and partial construction like List.map in `elm-optimize-level-2`.

Please note that you need to manually change the JS code for this benchmark to work.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Implementation to be replaced manually by:

```js
var $author$project$ImprovingPerformance$ElmCore$ListFilterMap$filterMapNew = F2(function (f, xs) {
  var tmp = _List_Cons(undefined, _List_Nil);
  var end = tmp;
  for (; xs.b; xs = xs.b) {
    var m = f(xs.a);
    if (!m.$) {
      var next = _List_Cons(m.a, _List_Nil);
      end.b = next;
      end = next;
    }
  }
  return tmp.b;
});
```

-}
filterMapNew : (a -> Maybe b) -> List a -> List b
filterMapNew f xs =
    List.filterMap f xs


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
    describe "List.filterMap"
        [ Benchmark.compare "10 elements"
            "Original"
            (\() -> List.filterMap Just tenElements)
            "With JS-for"
            (\() -> filterMapNew Just tenElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> List.filterMap Just thousandElements)
            "With JS-for"
            (\() -> filterMapNew Just thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
