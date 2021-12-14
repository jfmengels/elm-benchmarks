module ImprovingPerformance.ElmCore.ListTake exposing (main)

{-| Changing `List.take` to use JS-iteration and partial construction like List.map in `elm-optimize-level-2`.

Please note that you need to manually change the JS code for this benchmark to work.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Implementation to be replaced manually by:

```js
var $author$project$ImprovingPerformance$ElmCore$ListTake$takeNew = F2(function(n, xs) {
  var tmp = _List_Cons(undefined, _List_Nil);
  var end = tmp;
  for (var i = 0; i < n && xs.b; xs = xs.b, i++) {
    var next = _List_Cons(xs.a, _List_Nil);
    end.b = next;
    end = next;
  }
  return tmp.b;
});
```

-}
takeNew : Int -> List a -> List a
takeNew n list =
    List.take n list


suite : Benchmark
suite =
    let
        thousandElements : List Int
        thousandElements =
            List.range 1 1000
    in
    describe "List.take"
        [ Benchmark.compare "10 elements"
            "Original"
            (\() -> List.take 10 thousandElements)
            "With JS-for"
            (\() -> takeNew 10 thousandElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> List.take 1000 thousandElements)
            "With JS-for"
            (\() -> takeNew 1000 thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
