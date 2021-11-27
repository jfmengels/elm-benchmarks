module ImprovingPerformance.ElmCore.ListSort exposing (main)

{-| Changing `List.sort` to construct a List directly while iterating on the list, without creating a new JS array
beforehand and an intermediary one for the result.

The sorting algorithm is some kind of insertion sort, where we insert into a new list and find the appropriate position
by iterating through the list.

Please note that you need to manually change the JS code for this benchmark to work.

Results: This implementation is pretty fast for small lists ( > 100) but becomes slower for big lists (somewhere between 100 and 1000 elements).
This is very likely because iterating through the resulting list to find the appropriate position at some point becomes
bigger than the cost of using list\_fromArray and list\_toArray.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Implementation to be replaced manually by:

```js
var $author$project$ImprovingPerformance$ElmCore$ListSort$altSort = F2(function (f, xs) {
    if (!xs.b) {
        return xs;
    }

    var head = _List_Cons(undefined, _List_Cons(xs.a, _List_Nil));
    console.log(xs.a, _List_toArray(head.b))
    var end = head;
    for (xs = xs.b; xs.b; xs = xs.b) {
        var compVal = f(xs.a);
        // TODO: Use '<= 0' ?
        if (_Utils_cmp(compVal, f(head.b.a)) < 0) {
            head.b = _List_Cons(xs.a, head.b);
        } else {
            var y = head;
            for (; y.b.b && _Utils_cmp(compVal, f(y.b.a)) >= 0; y = y.b) { } // WHILE_CONSES
            if (y.b.b) {
                console.log(2)
                // Inserting somewhere in the middle
                y.b.b = _List_Cons(y.b.a, y.b.b);
                y.b.a = xs.a;
            } else {
                // This is the highest value, adding to the end
                y.b = _List_Cons(xs.a, _List_Nil);
            }
        }
    }
    console.log(_List_toArray(head.b))
    return head.b;
});
```

-}
altSort =
    List.sort


{-|

```js
function shuffle(list) {
    var array = _List_toArray(list);
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return _List_fromArray(array);
}
```

-}
shuffle list =
    list


suite : Benchmark
suite =
    let
        tenElements : List number
        tenElements =
            shuffle (List.range 1 10)

        thousandElements : List number
        thousandElements =
            shuffle (List.range 1 1000)
    in
    describe "List.sort"
        [ Benchmark.compare "10 elements"
            "Original"
            (\() -> List.sort tenElements)
            "Alternative"
            (\() -> altSort tenElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> List.sort thousandElements)
            "Alternative"
            (\() -> altSort thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
