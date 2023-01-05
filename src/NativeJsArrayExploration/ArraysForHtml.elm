module NativeJsArrayExploration.ArraysForHtml exposing (main)

{-| This benchmark aims to determine whether it would make sense to pass JavaScript Arrays instead of Elm Lists for the
children and attributes that are passed directly to elm/html functions (attributes and children), when literal lists are
provided, thereby avoiding unnecessary conversions which end up also being slower than array iterations.

When non-literal lists are given, then it's handled as a list as is currently done (as of 0.19.1).

Please note that you need to manually change the JS code in 3 parts for this benchmark to work. See instructions in a section below.


## Applied change

This rough attempt does 2 things:

1.  Remove the calls to `_List_fromArray` in the view code - which removes a bunch of memory and CPU steps to create a list
2.  Support JavaScript Arrays in the functions `_VirtualDom_nodeNS` and `_VirtualDom_organizeFacts`, by adding a check
    whether the "list" argument is a JavaScript Array. If so, call a modified version of the same function tailored to Arrays

It may be possible we can avoid the duplication of those 2 functions, but that requires further fine-tuning and benchmarking.


## Results

This seems to work quite well. This probably needs to be benchmarked more accurately — it's hard/tedious to test both
versions during the same run due to how many layers would need to be duplicated — but I'm getting around
a 60% improvement on Chrome, and 25-40% improvement on Firefox.

Since literal lists are such a common-use of the `elm/html`'s API, this is very promising.


## Conclusion

This is a pretty remarkable improvement, for very little change. We should probably benchmark more thoroughly (not only
the happy path) and also in a larger setting (with both literal and non-literal lists).

We can start asking more questions:

  - Does it make sense to apply this to other APIs? If so, which ones?
  - Can Elm's compiled output easily support iterating through either of JS Arrays and Elm Lists?
  - How can we get the Elm compiler (and/or `elm-optimize-level-2`) to detect that it can remove the `_List_fromArray`
    calls from functions which indirectly call VirtualDom and similar functions?
  - How far can and should we push the analysis to detect literal lists? Should we try to detect when the argument is a
    let variable used only as an argument to Array-compatible functions?
    Ex: `let attrs = [...] in Html.div attrs []`


## Replacements to apply

1- Replace `_VirtualDom_nodeNS` by the following:

```js
var _VirtualDom_nodeNS = F2(function (namespace, tag) {
  return F2(function (factList, kidList) {
    if (Array.isArray(kidList)) {
      return _VirtualDom_nodeNS_usingArray(namespace, tag, factList, kidList);
    }

    for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
    {
      var kid = kidList.a;
      descendantsCount += kid.b || 0;
      kids.push(kid);
    }
    descendantsCount += kids.length;

    return {
      $: 1,
      c: tag,
      d: _VirtualDom_organizeFacts(factList),
      e: kids,
      f: namespace,
      b: descendantsCount,
    };
  });
});

function _VirtualDom_nodeNS_usingArray(namespace, tag, factList, kids) {
  for (var i = 0, descendantsCount = kids.length; i < kids.length; i++) {
    descendantsCount += kids[i].b || 0;
  }

  return {
    $: 1,
    c: tag,
    d: _VirtualDom_organizeFacts(factList),
    e: kids,
    f: namespace,
    b: descendantsCount,
  };
}
```

2- Replace `_VirtualDom_organizeFacts` by:

```js
function _VirtualDom_organizeFacts(factList) {
  if (Array.isArray(factList)) {
    return _VirtualDom_organizeFacts_usingArray(factList);
  }

  for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
  {
    var entry = factList.a;

    var tag = entry.$;
    var key = entry.n;
    var value = entry.o;

    if (tag === "a2") {
      key === "className"
        ? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
        : (facts[key] = _Json_unwrap(value));

      continue;
    }

    var subFacts = facts[tag] || (facts[tag] = {});
    tag === "a3" && key === "class"
      ? _VirtualDom_addClass(subFacts, key, value)
      : (subFacts[key] = value);
  }

  return facts;
}

function _VirtualDom_organizeFacts_usingArray(factArray) {
  for (var i = 0, facts = {}; i < factArray.length; i++) {
    var entry = factArray[i];

    var tag = entry.$;
    var key = entry.n;
    var value = entry.o;

    if (tag === "a2") {
      key === "className"
        ? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
        : (facts[key] = _Json_unwrap(value));

      continue;
    }

    var subFacts = facts[tag] || (facts[tag] = {});
    tag === "a3" && key === "class"
      ? _VirtualDom_addClass(subFacts, key, value)
      : (subFacts[key] = value);
  }

  return facts;
}
```

3- Replace the benchmark code (see the next function below) to remove the `_List_fromArray`.

-}

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Html exposing (Html)
import Html.Attributes
import Svg
import Svg.Attributes


{-| To replace by the following code, when evaluating the optimized version.

```js
var $author$project$NativeJsArrayExploration$ArraysForHtml$view = function (_v0) {
    return A2(
        $elm$html$Html$div,
        [
            $elm$html$Html$Attributes$class('some'),
            $elm$html$Html$Attributes$class('classes'),
            $elm$html$Html$Attributes$class('to'),
            $elm$html$Html$Attributes$class('create'),
            $elm$html$Html$Attributes$class('attributes'),
            $elm$html$Html$Attributes$id('attributes')
        ],
        [
            $elm$html$Html$text('Some'),
            A2($elm$html$Html$button,
                [$elm$html$Html$Attributes$class('button')],
                [$elm$html$Html$text('Button')]
            ),
            $elm$html$Html$text('to make some'),
            A2(
              $elm$html$Html$p,
              [],
              [$elm$html$Html$text('context')]
            )
        ]
    );
};
```

-}
view : () -> Html msg
view () =
    Html.div
        [ Html.Attributes.class "some"
        , Html.Attributes.class "classes"
        , Html.Attributes.class "to"
        , Html.Attributes.class "create"
        , Html.Attributes.class "attributes"
        , Html.Attributes.id "attributes"
        ]
        [ Html.text "Some"
        , Html.button [ Html.Attributes.class "button" ] [ Html.text "Button" ]
        , Html.text "to make some"
        , Html.p [] [ Html.text "context" ]
        , Svg.svg []
            [ Svg.rect
                [ Svg.Attributes.x "10"
                , Svg.Attributes.y "10"
                ]
                []
            ]
        ]


suite : Benchmark
suite =
    Benchmark.benchmark "Creating some Html" view


main : BenchmarkProgram
main =
    program suite
