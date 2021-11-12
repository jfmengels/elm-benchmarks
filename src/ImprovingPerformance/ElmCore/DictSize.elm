module ImprovingPerformance.ElmCore.DictSize exposing (main)

{-| Changing `Dict.size` to a tail-call optimized recursive function by creating a manual stack.

Results: This approach is slower.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Original, taken from <https://github.com/elm/core/pull/1033>
-}
size : Dict k v -> Int
size dict =
    sizeHelp 0 dict


sizeHelp : Int -> Dict k v -> Int
sizeHelp n dict =
    case dict of
        RBNode_elm_builtin _ _ _ left right ->
            sizeHelp (sizeHelp (n + 1) right) left

        _ ->
            n


altSize : Dict k v -> Int
altSize dict =
    altSizeHelp [ dict ] 0


altSizeHelp : List (Dict k v) -> Int -> Int
altSizeHelp dicts n =
    case dicts of
        [] ->
            n

        dict :: rest ->
            case dict of
                RBNode_elm_builtin _ _ _ left right ->
                    altSizeHelp (left :: right :: rest) (n + 1)

                _ ->
                    altSizeHelp rest n


type Dict k v
    = RBNode_elm_builtin NColor k v (Dict k v) (Dict k v)
    | RBEmpty_elm_builtin
      -- Temporary state used when removing elements
    | RBBlackMissing_elm_builtin (Dict k v)


type NColor
    = Red
    | Black


suite : Benchmark
suite =
    let
        tenElements : Dict Int Int
        tenElements =
            List.range 1 10
                |> List.map (\n -> ( n, n ))
                |> fromList

        thousandElements : Dict Int Int
        thousandElements =
            List.range 1 1000
                |> List.map (\n -> ( n, n ))
                |> fromList
    in
    describe "Dict.size"
        [ Benchmark.compare "Empty dicts"
            "Original"
            (\() -> size empty)
            "Using compare"
            (\() -> altSize empty)
        , Benchmark.compare "Dicts of size 10"
            "Original"
            (\() -> size tenElements)
            "Using compare"
            (\() -> altSize tenElements)
        , Benchmark.compare "Dicts of size 1000"
            "Original"
            (\() -> size thousandElements)
            "With stack"
            (\() -> altSize thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite



-- UNRELATED DISC FUNCTIONS


fromList : List ( comparable, v ) -> Dict comparable v
fromList assocs =
    List.foldl (\( key, value ) dict -> insert key value dict) empty assocs


insert : comparable -> v -> Dict comparable v -> Dict comparable v
insert key value dict =
    -- Root node is always Black
    case insertHelp key value dict of
        RBNode_elm_builtin Red k v l r ->
            RBNode_elm_builtin Black k v l r

        x ->
            x


insertHelp : comparable -> v -> Dict comparable v -> Dict comparable v
insertHelp key value dict =
    case dict of
        RBNode_elm_builtin nColor nKey nValue nLeft nRight ->
            case compare key nKey of
                LT ->
                    case insertHelp key value nLeft of
                        RBNode_elm_builtin Red lK lV (RBNode_elm_builtin Red llK llV llLeft llRight) lRight ->
                            RBNode_elm_builtin Red lK lV (RBNode_elm_builtin Black llK llV llLeft llRight) (RBNode_elm_builtin Black nKey nValue lRight nRight)

                        newLeft ->
                            RBNode_elm_builtin nColor nKey nValue newLeft nRight

                EQ ->
                    RBNode_elm_builtin nColor nKey value nLeft nRight

                GT ->
                    case insertHelp key value nRight of
                        RBNode_elm_builtin Red rK rV rLeft rRight ->
                            case nLeft of
                                RBNode_elm_builtin Red lK lV lLeft lRight ->
                                    RBNode_elm_builtin
                                        Red
                                        nKey
                                        nValue
                                        (RBNode_elm_builtin Black lK lV lLeft lRight)
                                        (RBNode_elm_builtin Black rK rV rLeft rRight)

                                _ ->
                                    RBNode_elm_builtin nColor rK rV (RBNode_elm_builtin Red nKey nValue nLeft rLeft) rRight

                        newRight ->
                            RBNode_elm_builtin nColor nKey nValue nLeft newRight

        _ ->
            -- New nodes are always red. If it violates the rules, it will be fixed
            -- when balancing.
            RBNode_elm_builtin Red key value RBEmpty_elm_builtin RBEmpty_elm_builtin


empty : Dict k v
empty =
    RBEmpty_elm_builtin
