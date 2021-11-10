module StringExtra.LeftOfBack exposing (main)

{-| Changing `String.Extra.leftOfBack`. I mostly took the improvements from `StringExtra.RightOfBack` and re-used them.

Related benchmarks: StringExtra.RightOfBack

-}

import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner


leftOfBack : String -> String -> String
leftOfBack pattern string =
    string
        |> String.indexes pattern
        |> List.reverse
        |> List.head
        |> Maybe.map (\a -> String.left a string)
        |> Maybe.withDefault ""


alternative : String -> String -> String
alternative pattern string =
    case String.indexes pattern string of
        [] ->
            ""

        firstIndex :: rest ->
            case last rest of
                Just lastIndex ->
                    String.slice 0 lastIndex string

                Nothing ->
                    String.slice 0 firstIndex string


last : List a -> Maybe a
last items =
    case items of
        [] ->
            Nothing

        [ x ] ->
            Just x

        _ :: rest ->
            last rest


suite : Benchmark
suite =
    rank "String.Extra.leftOfBack"
        (\f -> f "_" "This_is_a_test_string")
        [ ( "Original", leftOfBack )
        , ( "Alternative", alternative )
        ]


main : BenchmarkRunner.Program
main =
    BenchmarkRunner.program suite
