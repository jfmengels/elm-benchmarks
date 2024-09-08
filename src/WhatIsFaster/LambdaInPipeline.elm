module WhatIsFaster.LambdaInPipeline exposing (main)

{-| This benchmark aims to figure out whether using a lambda in a pipeline is slower than using a let expression.

In Firefox, splitting the pipeline in order to remove a function seems to improve performance by about 30%.
In Chrome, the two are equivalent.

-}

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    let
        list : List Int
        list =
            List.range 1 100
    in
    Benchmark.compare "2 functions"
        "Pipeline with lambda"
        (\() -> List.map pipelineWithLambda list)
        "Split pipeline"
        (\() -> List.map splitPipeline list)


pipelineWithLambda : number -> number
pipelineWithLambda n =
    n
        |> increment
        |> (\x -> subtract x 5)
        |> increment


splitPipeline : number -> number
splitPipeline n =
    let
        x : number
        x =
            n |> increment
    in
    subtract x 5
        |> increment


increment : number -> number
increment n =
    n + 1


subtract : number -> number -> number
subtract a b =
    a - b


main : BenchmarkProgram
main =
    program suite
