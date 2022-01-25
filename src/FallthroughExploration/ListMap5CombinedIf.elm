module FallthroughExploration.ListMap5CombinedIf exposing (main)

{-| Changing `List.map5` to use combined ifs instead of duplicated else cases.

Please note that you need to manually change the JS code for this benchmark to work.

Results (both Chrome and Firefox): Large improvements for small inputs, but large deterioration for large inputs.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


map5Untouched : (a -> b -> c -> d -> e -> result) -> List a -> List b -> List c -> List d -> List e -> List result
map5Untouched f zs ys xs ws vs =
    case zs of
        z :: zs_ ->
            case ys of
                y :: ys_ ->
                    case xs of
                        x :: xs_ ->
                            case ws of
                                w :: ws_ ->
                                    case vs of
                                        v :: vs_ ->
                                            f z y x w v :: map5Untouched f zs_ ys_ xs_ ws_ vs_

                                        [] ->
                                            []

                                [] ->
                                    []

                        [] ->
                            []

                [] ->
                    []

        [] ->
            []


{-| Implementation to be replaced manually by:

```js
var $author$project$FallthroughExploration$ListMap5CombinedIf$map5Collapsed = F6(
    function (f, zs, ys, xs, ws, vs) {
        if (zs.b && zs.b.b && zs.b.b.b && zs.b.b.b.b && zs.b.b.b.b.b) {
            var z = zs.a;
            var zs_ = zs.b;
            var y = ys.a;
            var ys_ = ys.b;
            var x = xs.a;
            var xs_ = xs.b;
            var w = ws.a;
            var ws_ = ws.b;
            var v = vs.a;
            var vs_ = vs.b;
            return A2(
                $elm$core$List$cons,
                A5(f, z, y, x, w, v),
                A6($author$project$FallthroughExploration$ListMap5CombinedIf$map5Collapsed, f, zs_, ys_, xs_, ws_, vs_));
        }
        return _List_Nil;
    });
```

-}
map5Collapsed : (a -> b -> c -> d -> e -> result) -> List a -> List b -> List c -> List d -> List e -> List result
map5Collapsed f zs ys xs ws vs =
    case zs of
        z :: zs_ ->
            case ys of
                y :: ys_ ->
                    case xs of
                        x :: xs_ ->
                            case ws of
                                w :: ws_ ->
                                    case vs of
                                        v :: vs_ ->
                                            f z y x w v :: map5Untouched f zs_ ys_ xs_ ws_ vs_

                                        [] ->
                                            []

                                [] ->
                                    []

                        [] ->
                            []

                [] ->
                    []

        [] ->
            []


suite : Benchmark
suite =
    let
        fourElements : List Int
        fourElements =
            List.range 1 4

        thousandElements : List Int
        thousandElements =
            List.range 1 1000
    in
    describe "List.map5"
        [ Benchmark.compare "4 elements"
            "With combined if"
            (\() -> map5Collapsed add fourElements fourElements fourElements fourElements fourElements)
            "Original"
            (\() -> map5Untouched add fourElements fourElements fourElements fourElements fourElements)
        , Benchmark.compare "1000 elements"
            "With combined if"
            (\() -> map5Collapsed add thousandElements thousandElements thousandElements thousandElements thousandElements)
            "Original"
            (\() -> map5Untouched add thousandElements thousandElements thousandElements thousandElements thousandElements)
        ]


add : number -> number -> number -> number -> number -> number
add a b c d e =
    a + b + c + d + e


main : BenchmarkProgram
main =
    program suite
