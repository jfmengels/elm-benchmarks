module WhatIsFaster.ArraySingleton exposing (main)

{-| There is no `Array.singleton`. What is the fastest way of implementing it?

Results:

  - Chrome: `Array.repeat 1 x` is a bit faster.
  - Firefox and Safari: `Array.push x Array.empty` is a bit faster.

`Array.push x Array.empty` is still very fast in Chrome, so if you want
good performance for many, maybe choose that.

`Array.fromList [x]` is much slower in both Chrome and Firefox.

    | Implementation           | Chrome      | Firefox    | Safari     |
    | ------------------------ | ----------- | ---------- | ---------- |
    | Array.push x Array.empty | 121,729,331 | 31,147,646 | 39,156,246 |
    | Array.repeat 1 x         | 132,043,035 | 19,022,172 | 33,638,687 |
    | Array.fromList [x]       | 31,890,391  | 12,876,852 | 22,430,539 |

(runs/second)

-}

import Array
import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner


suite : Benchmark
suite =
    rank "Array.singleton"
        (\fn -> fn ())
        [ ( "Array.fromList [x]"
          , \() -> Array.fromList [ x ]
          )
        , ( "Array.push x Array.empty"
          , \() -> Array.push x Array.empty
          )
        , ( "Array.repeat 1 x"
          , \() -> Array.repeat 1 x
          )
        ]


x : Int
x =
    0


main : BenchmarkRunner.Program
main =
    BenchmarkRunner.program suite
