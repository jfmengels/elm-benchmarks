module ImprovingPerformance.ElmCore.ListMap2 exposing (main)

{-| Changing `List.map2` to construct a List directly, without creating a new JS array.

Please note that you need to manually change the JS code for this benchmark to work.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Implementation to be replaced manually by:

```js
var $author$project$ImprovingPerformance$ElmCore$ListMap2$listMap2v2 = F3(function(f, xs, ys) {
  var tmp = _List_Cons(undefined, _List_Nil);
  var end = tmp;
  for (; xs.b && ys.b; xs = xs.b, ys = ys.b) {
    var next = _List_Cons(A2(f, xs.a, ys.a), _List_Nil);
    end.b = next;
    end = next;
  }
  return tmp.b;
});
```

-}
listMap2v2 =
    List.map2


suite : Benchmark
suite =
    let
        tenElements : List number
        tenElements =
            List.repeat 10 1

        thousandElements : List number
        thousandElements =
            List.repeat 1000 1
    in
    describe "List.map2"
        [ Benchmark.compare "10 elements"
            "Original"
            (\() -> List.map2 Tuple.pair tenElements tenElements)
            "Alternative"
            (\() -> listMap2v2 Tuple.pair tenElements tenElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> List.map2 Tuple.pair thousandElements thousandElements)
            "Alternative"
            (\() -> listMap2v2 Tuple.pair thousandElements thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
