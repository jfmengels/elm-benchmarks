module ImprovingPerformance.ListExtra.MinimumBy exposing (main)

{-| Changing `List.Extra.minimumBy` to not recreate the tuple containing the minimal value.

The results show that there is indeed a cost to creating these tuples over and over again.

The same change can be applied to `List.Extra.maximumBy`.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


minimumBy : (a -> comparable) -> List a -> Maybe a
minimumBy f ls =
    let
        minBy : a -> ( a, comparable ) -> ( a, comparable )
        minBy x ( y, fy ) =
            let
                fx : comparable
                fx =
                    f x
            in
            if fx < fy then
                ( x, fx )

            else
                ( y, fy )
    in
    case ls of
        [ l_ ] ->
            Just l_

        l_ :: ls_ ->
            Just <| Tuple.first <| List.foldl minBy ( l_, f l_ ) ls_

        _ ->
            Nothing


minimumByWithAliasing : (a -> comparable) -> List a -> Maybe a
minimumByWithAliasing f ls =
    let
        minBy : a -> ( a, comparable ) -> ( a, comparable )
        minBy x (( _, fy ) as min) =
            let
                fx : comparable
                fx =
                    f x
            in
            if fx < fy then
                ( x, fx )

            else
                min
    in
    case ls of
        [ l_ ] ->
            Just l_

        l_ :: ls_ ->
            Just <| Tuple.first <| List.foldl minBy ( l_, f l_ ) ls_

        _ ->
            Nothing


suite : Benchmark
suite =
    let
        tenElements : List String
        tenElements =
            List.range 1 10
                |> List.map String.fromInt

        thousandElements : List String
        thousandElements =
            List.range 1 1000
                |> List.map String.fromInt
    in
    describe "List.Extra.minimumBy"
        [ Benchmark.compare "0 elements"
            "Original"
            (\() -> minimumBy String.length [])
            "With aliasing"
            (\() -> minimumByWithAliasing String.length [])
        , Benchmark.compare "10 elements"
            "Original"
            (\() -> minimumBy String.length tenElements)
            "With aliasing"
            (\() -> minimumByWithAliasing String.length tenElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> minimumBy String.length thousandElements)
            "With aliasing"
            (\() -> minimumByWithAliasing String.length thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
