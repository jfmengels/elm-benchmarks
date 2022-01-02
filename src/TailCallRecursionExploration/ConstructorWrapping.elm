module TailCallRecursionExploration.ConstructorWrapping exposing (main)

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


type Pairs
    = Nil
    | Cons Int Int Pairs


swap : Pairs -> Pairs
swap pairs =
    case pairs of
        Nil ->
            Nil

        Cons x y ps ->
            Cons y x (swap ps)


suite : Benchmark
suite =
    let
        data : Pairs
        data =
            Cons
                1
                2
                (Cons
                    3
                    4
                    (Cons
                        5
                        6
                        (Cons
                            7
                            8
                            (Cons
                                9
                                10
                                Nil
                            )
                        )
                    )
                )
    in
    Benchmark.benchmark "Swap"
        (\() -> swap data)


main : BenchmarkProgram
main =
    program suite
