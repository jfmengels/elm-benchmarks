module ImprovingPerformance.StringExtra.RightOfBack exposing (main)

{-| Changing `String.Extra.rightOfBack`. There were several places where there was unnecessary overhead, so I tried
multiple iterative improvements.

Related benchmarks: ImprovingPerformance.StringExtra.LeftOfBack

-}

import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner


rightOfBack : String -> String -> String
rightOfBack pattern string =
    string
        |> String.indexes pattern
        |> List.reverse
        |> List.head
        |> Maybe.map ((+) (String.length pattern) >> (\a -> String.dropLeft a string))
        |> Maybe.withDefault ""


usingLambda : String -> String -> String
usingLambda pattern string =
    string
        |> String.indexes pattern
        |> List.reverse
        |> List.head
        |> Maybe.map (\lastIndex -> String.dropLeft (String.length pattern + lastIndex) string)
        |> Maybe.withDefault ""


usingCaseOf : String -> String -> String
usingCaseOf pattern string =
    case
        string
            |> String.indexes pattern
            |> List.reverse
            |> List.head
    of
        Just lastIndex ->
            String.dropLeft (String.length pattern + lastIndex) string

        Nothing ->
            ""


usingLast : String -> String -> String
usingLast pattern string =
    case
        string
            |> String.indexes pattern
            |> last
    of
        Just lastIndex ->
            String.dropLeft (String.length pattern + lastIndex) string

        Nothing ->
            ""


usingPatternOnList : String -> String -> String
usingPatternOnList pattern string =
    case String.indexes pattern string of
        [] ->
            ""

        firstIndex :: rest ->
            case last rest of
                Just lastIndex ->
                    String.dropLeft (String.length pattern + lastIndex) string

                Nothing ->
                    String.dropLeft (String.length pattern + firstIndex) string


{-| When run individually against the others, seems to perform the best
-}
usingSlice : String -> String -> String
usingSlice pattern string =
    case String.indexes pattern string of
        [] ->
            ""

        firstIndex :: rest ->
            case last rest of
                Just lastIndex ->
                    String.slice (String.length pattern + lastIndex) (String.length string) string

                Nothing ->
                    String.slice (String.length pattern + firstIndex) (String.length string) string


{-| I tried being smart, but this is by far the worst performing version
-}
reversingStrings : String -> String -> String
reversingStrings pattern string =
    let
        reversedString : String
        reversedString =
            String.reverse string
    in
    case String.indexes (String.reverse pattern) reversedString of
        [] ->
            ""

        first :: _ ->
            String.slice 0 first reversedString
                |> String.reverse


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
    rank "String.Extra.rightOfBack"
        (\f -> f "_" "This_is_a_test_string")
        [ ( "Original", rightOfBack )
        , ( "Using lambda", usingLambda )
        , ( "Using case of", usingCaseOf )
        , ( "Using last", usingLast )
        , ( "Using pattern on list", usingPatternOnList )
        , ( "Using String.slice", usingSlice )
        , ( "By reversing strings", reversingStrings )
        ]


main : BenchmarkRunner.Program
main =
    BenchmarkRunner.program suite
