module ImprovingPerformance.TailCallRecursionVariableAssignments exposing (main)

{-| Removing the unnecessary variable assignments found in the while loops of tail-call optimized recursive calls.

Please note that you need to manually change the JS code for this benchmark to work.

Results: Barely any change. It's probably more interesting for reducing asset size than for performance,
but likely also only marginally so.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Gets compiled to

```js
var $author$project$ImprovingPerformance$TailCallRecursionVariableAssignments$factorial1 = F6(
    function (a, b, c, d, n, acc) {
        factorial1:
        while (true) {
            if (n <= 1) {
                return acc;
            } else {
                var $temp$a = a,
                    $temp$b = b,
                    $temp$c = c,
                    $temp$d = d,
                    $temp$n = n - 1,
                    $temp$acc = acc * n;
                a = $temp$a;
                b = $temp$b;
                c = $temp$c;
                d = $temp$d;
                n = $temp$n;
                acc = $temp$acc;
                continue factorial1;
            }
        }
    });
```

-}
factorial1 : a -> b -> c -> d -> Int -> Int -> Int
factorial1 a b c d n acc =
    if n <= 1 then
        acc

    else
        factorial1 a b c d (n - 1) (acc * n)


{-| Replace the code for this function by the following:

```js
var $author$project$ImprovingPerformance$TailCallRecursionVariableAssignments$factorial2 = F6(
    function (a, b, c, d, n, acc) {
        factorial2:
        while (true) {
            if (n <= 1) {
                return acc;
            } else {
                var $temp$n = n - 1,
                    $temp$acc = acc * n;
                n = $temp$n;
                acc = $temp$acc;
                continue factorial2;
            }
        }
    });
```

-}
factorial2 : a -> b -> c -> d -> Int -> Int -> Int
factorial2 a b c d n acc =
    if n <= 1 then
        acc

    else
        factorial2 a b c d (n - 1) (acc * n)


suite : Benchmark
suite =
    describe "Tail-call optimization loop"
        [ Benchmark.compare "factorial of 1000"
            "Original"
            (\() -> factorial1 0 0 0 0 1000 1)
            "Without unnecessary variable assignments"
            (\() -> factorial2 0 0 0 0 1000 1)
        ]


main : BenchmarkProgram
main =
    program suite
