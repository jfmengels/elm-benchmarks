module DictMerge exposing (main)

{-| Changing `Dict.merge` to use `Basics.compare` rather than comparing the value twice.

Results: There isn't a noticeable difference, maybe because of the overhead of `compare` in creating an `Order` and then pattern matching on it.
Maybe this change would be more interesting if `_Utils_cmp` was available in Elm-land, reducing the overhead.

I tried using the following JS code manually, and that version seems faster, but only marginally.

```js
var _Utils_cmp_Hack = F2(_Utils_cmp);
var $author$project$DictMerge$altDictMerge = F6(
    function (leftStep, bothStep, rightStep, leftDict, rightDict, initialResult) {
        var stepState = F3(
            function (rKey, rValue, _v0) {
                stepState:
                while (true) {
                    var list = _v0.a;
                    var result = _v0.b;
                    if (!list.b) {
                        return _Utils_Tuple2(
                            list,
                            A3(rightStep, rKey, rValue, result));
                    } else {
                        var _v2 = list.a;
                        var lKey = _v2.a;
                        var lValue = _v2.b;
                        var rest = list.b;


                        var _v3 = A2(_Utils_cmp_Hack, lKey, rKey);
                            return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;

                        if (n < 0) {
                            var $temp$rKey = rKey,
                                $temp$rValue = rValue,
                                $temp$_v0 = _Utils_Tuple2(
                                rest,
                                A3(leftStep, lKey, lValue, result));
                            rKey = $temp$rKey;
                            rValue = $temp$rValue;
                            _v0 = $temp$_v0;
                            continue stepState;
                        }
                        if (n) {
                            return _Utils_Tuple2(
                                list,
                                A3(rightStep, rKey, rValue, result));
                        }
                        return _Utils_Tuple2(
                            rest,
                            A4(bothStep, lKey, lValue, rValue, result));
                    }
                }
            });
```

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Dict exposing (Dict)


{-| Original version:

    merge :
        (comparable -> a -> result -> result)
        -> (comparable -> a -> b -> result -> result)
        -> (comparable -> b -> result -> result)
        -> Dict comparable a
        -> Dict comparable b
        -> result
        -> result
    merge leftStep bothStep rightStep leftDict rightDict initialResult =
        let
            stepState rKey rValue ( list, result ) =
                case list of
                    [] ->
                        ( list, rightStep rKey rValue result )

                    ( lKey, lValue ) :: rest ->
                        if lKey < rKey then
                            stepState rKey rValue ( rest, leftStep lKey lValue result )

                        else if lKey > rKey then
                            ( list, rightStep rKey rValue result )

                        else
                            ( rest, bothStep lKey lValue rValue result )

            ( leftovers, intermediateResult ) =
                foldl stepState ( toList leftDict, initialResult ) rightDict
        in
        List.foldl (\( k, v ) result -> leftStep k v result) intermediateResult leftovers

-}
altDictMerge :
    (comparable -> a -> result -> result)
    -> (comparable -> a -> b -> result -> result)
    -> (comparable -> b -> result -> result)
    -> Dict comparable a
    -> Dict comparable b
    -> result
    -> result
altDictMerge leftStep bothStep rightStep leftDict rightDict initialResult =
    let
        stepState : comparable -> b -> ( List ( comparable, a ), result ) -> ( List ( comparable, a ), result )
        stepState rKey rValue ( list, result ) =
            case list of
                [] ->
                    ( list, rightStep rKey rValue result )

                ( lKey, lValue ) :: rest ->
                    case compare lKey rKey of
                        LT ->
                            stepState rKey rValue ( rest, leftStep lKey lValue result )

                        GT ->
                            ( list, rightStep rKey rValue result )

                        EQ ->
                            ( rest, bothStep lKey lValue rValue result )

        ( leftovers, intermediateResult ) =
            Dict.foldl stepState ( Dict.toList leftDict, initialResult ) rightDict
    in
    List.foldl (\( k, v ) result -> leftStep k v result) intermediateResult leftovers


suite : Benchmark
suite =
    let
        elementsLeft : Int -> Dict Int Int
        elementsLeft howMany =
            List.range 0 ((howMany // 2) - 1)
                |> List.concatMap (\i -> [ ( i * 3 + 1, i * 3 + 1 ), ( i * 3 + 2, i * 3 + 2 ) ])
                |> Dict.fromList

        elementsRight : Int -> Dict Int Int
        elementsRight howMany =
            List.range 0 ((howMany // 2) - 1)
                |> List.concatMap (\i -> [ ( i * 3 + 2, i * 3 + 2 ), ( i * 3 + 3, i * 3 + 3 ) ])
                |> Dict.fromList

        tenElementsLeft : Dict Int Int
        tenElementsLeft =
            elementsLeft 10

        tenElementsRight : Dict Int Int
        tenElementsRight =
            elementsRight 10

        thousandElementsLeft : Dict Int Int
        thousandElementsLeft =
            elementsLeft 1000

        thousandElementsRight : Dict Int Int
        thousandElementsRight =
            elementsRight 1000

        addAndInsert : comparable -> number -> number -> Dict comparable number -> Dict comparable number
        addAndInsert key a b dict =
            Dict.insert key (a + b) dict
    in
    describe "Dict.merge"
        [ Benchmark.compare "Empty dicts"
            "Original"
            (\() -> Dict.merge Dict.insert addAndInsert Dict.insert Dict.empty Dict.empty)
            "Using compare"
            (\() -> altDictMerge Dict.insert addAndInsert Dict.insert Dict.empty Dict.empty)
        , Benchmark.compare "Dicts of size 10"
            "Original"
            (\() -> Dict.merge Dict.insert addAndInsert Dict.insert tenElementsLeft tenElementsRight)
            "Using compare"
            (\() -> altDictMerge Dict.insert addAndInsert Dict.insert tenElementsLeft tenElementsRight)
        , Benchmark.compare "Dicts of size 1000"
            "Original"
            (\() -> Dict.merge Dict.insert addAndInsert Dict.insert thousandElementsLeft thousandElementsRight)
            "Using compare"
            (\() -> altDictMerge Dict.insert addAndInsert Dict.insert thousandElementsLeft thousandElementsRight)
        ]


main : BenchmarkProgram
main =
    program suite
