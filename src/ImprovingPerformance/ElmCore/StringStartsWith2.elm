module ImprovingPerformance.ElmCore.StringStartsWith2 exposing (main)

{-| Building on top of `ImprovingPerformance.ElmCore.StringStartsWith2` to try and find the ideal implementation.

The different alternatives:

1.  A `for` loop
2.  A `for` loop but backwards
3.  A `while` loop

Please note that you need to manually change the JS code for this benchmark to work. 2 functions have to be replaced.

Results:

  - Going backwards doesn't seem to make much difference.
  - On Firefox, all 3 implements are extremely similar.
  - On Chrome, the `while` seems to be ~10% faster than the rest, sometimes?

So the while loop seems to be the fastest implementation here.

Related benchmarks: ImprovingPerformance.ElmCore.StringStartsWith

-}

import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner


{-| To be replaced with:

    var $author$project$ImprovingPerformance$ElmCore$StringStartsWith2$altFor = F2(
        function (prefix, str) {
            var prefixLength = prefix.length;
            if (str.length < prefixLength) {
                return $elm$core$Basics$False;
            }
            for (var i = 0; i < prefixLength; i++) {
                if (prefix[i] !== str[i]) { return $elm$core$Basics$False; }
            }
            return $elm$core$Basics$True;
        });

-}
altFor : String -> String -> Bool
altFor prefix str =
    String.startsWith prefix str


{-| To be replaced with:

    var $author$project$ImprovingPerformance$ElmCore$StringStartsWith2$altForBackwards = F2(
        function (prefix, str) {
            var prefixLength = prefix.length;
            if (str.length < prefixLength) {
                return $elm$core$Basics$False;
            }
            for (var i = prefixLength - 1; i >= 0; i--) {
                if (prefix[i] !== str[i]) { return $elm$core$Basics$False; }
            }
            return $elm$core$Basics$True;
        });

-}
altForBackwards : String -> String -> Bool
altForBackwards prefix str =
    String.startsWith prefix str


{-| To be replaced with:

    var $author$project$ImprovingPerformance$ElmCore$StringStartsWith2$altWhile = F2(
        function (prefix, str) {
            var prefixLength = prefix.length;
            var i = -1;
            if (str.length < prefixLength) {
                return $elm$core$Basics$False;
            }
            while (++i < prefixLength) {
                if (prefix[i] !== str[i]) { return $elm$core$Basics$False; }
            }
            return $elm$core$Basics$True;
        });

-}
altWhile : String -> String -> Bool
altWhile prefix str =
    String.startsWith prefix str


veryLargeInput : String
veryLargeInput =
    String.repeat 10000 "we hide somewhere where no one will find us"


suite : Benchmark
suite =
    Benchmark.describe "String.startsWith"
        [ rank "Small inputs (found)"
            (\f -> f "the" "theory")
            functions
        , rank "Small inputs (not found)"
            (\f -> f "not" "theory")
            functions
        , rank "large inputs (found)"
            (\f -> f "we" veryLargeInput)
            functions
        , rank "large inputs (not found)"
            (\f -> f "not" veryLargeInput)
            functions
        ]


functions : List ( String, String -> String -> Bool )
functions =
    [ ( "For loops", altFor )
    , ( "For loops backwards", altForBackwards )
    , ( "While loop", altWhile )
    , ( "Original", String.startsWith )
    ]


main : BenchmarkRunner.Program
main =
    BenchmarkRunner.program suite
