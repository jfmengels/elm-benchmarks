module TailCallRecursionExploration.TreeWrapping exposing (main)

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


type Tree
    = Node Int
    | SingleChild Tree Int
    | TwoChildren Int Tree Tree


map : (Int -> Int) -> Tree -> Tree
map fn tree =
    case tree of
        Node value ->
            Node (fn value)

        SingleChild subTree value ->
            SingleChild (map fn subTree) (fn value)

        TwoChildren value left right ->
            TwoChildren (fn value) (map fn left) (map fn right)


suite : Benchmark
suite =
    let
        data : Tree
        data =
            SingleChild
                (TwoChildren
                    2
                    (SingleChild
                        (Node 4)
                        3
                    )
                    (SingleChild
                        (Node 6)
                        5
                    )
                )
                1
    in
    Benchmark.benchmark "Tree mapping"
        (\() -> map increment data)


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
