module ImprovingPerformance.RecordUpdate exposing (main)

{-| Removing the unnecessary variable assignments found in the while loops of tail-call optimized recursive calls.

Please note that you need to manually change the JS code for this benchmark to work.

You need to inject the following function in the compiled output:

```js
function _Utils_update2(oldRecord, updatedFields)
{
    for (var key in oldRecord)
    {
      var newValue = updatedFields[key];
      if (newValue === undefined) {
        updatedFields[key] = oldRecord[key];
      }
    }

    return oldRecord;
}
```

and then have the record updates in the second benchmark use `_Utils_update2` instead of `_Utils_update`.


## Results

The update itself is faster (+15% on Chrome, +85% on FF).

Unfortunately it also potentially changes the order of the keys, which can greatly de-optimize a function that works on
this kind of data (-5% on Chrome, -75% on FF, benchmark: <https://jsbench.me/qll20ki1aq/1>).

I conclude that this optimization is not worth it.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    let
        value : { a : number, b : number, c : number, d : number, e : number, f : number, g : number, h : number, i : number, j : number }
        value =
            { a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7, h = 8, i = 9, j = 10 }
    in
    Benchmark.compare "Record update"
        "Original"
        (\() ->
            let
                a1 =
                    { value | d = 4, a = 1, b = 2, c = 3, e = 5, f = 7, g = 8 }

                a2 =
                    { value | d = 1000 }
            in
            [ a1, a2 ]
        )
        "Suggested"
        (\() ->
            let
                a1 =
                    { value | d = 4, a = 1, b = 2, c = 3, e = 5, f = 7, g = 8 }

                a2 =
                    { value | d = 1000 }
            in
            [ a1, a2 ]
        )


main : BenchmarkProgram
main =
    program suite
