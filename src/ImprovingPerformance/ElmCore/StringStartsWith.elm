module ImprovingPerformance.ElmCore.StringStartsWith exposing (main)

{-| Testing different alternatives to `String.startsWith`.

The main issue with the original function is that it uses `indexOf`, which may go through the entire String
before noticing it doesn't find anything.

The different alternatives:

1.  ES2015 `String.prototype.startWith` function (not available in IE)
    <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/startsWith>
2.  Slicing the string with the size of the prefix to find, and checking whether they're equal.
3.  Iterating through the string and comparing one character at a time.

Please note that you need to manually change the JS code for this benchmark to work. 2 functions have to be replaced.

Also note that I have not fully checked whether the implementations always has the same behavior as the original.

Results: Option 3 (iterating with a loop) is the fastest. On Chrome it is as fast as option 1, but on Firefox it is about 50% faster than option 1.
The original is just horrendously slow for long strings where the value is not found.

-}

import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner


{-| To be replaced with:

    var $author$project$ImprovingPerformance$ElmCore$StringStartsWith$es2015_startsWith = F2(
        function (prefix, str) {
            return str.startsWith(prefix);
        });

-}
es2015_startsWith : String -> String -> Bool
es2015_startsWith prefix str =
    String.startsWith prefix str


{-| To be replaced with:

    var $author$project$ImprovingPerformance$ElmCore$StringStartsWith$checkCharactersInALoop = F2(
        function (prefix, str) {
            var prefixLength = prefix.length;
            var strLength = str.length;
            var i;
            if (strLength < prefixLength) {
                return $elm$core$Basics$False;
            }
            for (i = 0; i < prefixLength; i++) {
                if (prefix[i] !== str[i]) { return $elm$core$Basics$False; }
            }
            return $elm$core$Basics$True;
        });

-}
checkCharactersInALoop : String -> String -> Bool
checkCharactersInALoop prefix str =
    String.startsWith prefix str


sliceThenCompare : String -> String -> Bool
sliceThenCompare prefix str =
    String.slice 0 (String.length prefix) str == prefix


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
    [ ( "Original", String.startsWith )
    , ( "Slice then compare", sliceThenCompare )
    , ( "Check characters in a loop", checkCharactersInALoop )
    , ( "ES2015 startsWith", es2015_startsWith )
    ]


main : BenchmarkRunner.Program
main =
    BenchmarkRunner.program suite
