# Misc benchmarks for Elm code

This repository is a collection of benchmarks I created, through explorations on how to make Elm code faster and plain curiosity.

**NOTE** that all of these benchmarks are to be taken with a grain of salt. For instance, some things I tried improving turn out
worse than the original idea, some may not see improvements in all of the JavaScript runtimes, and some amazing results get
eclipsed by better changes already in [`elm-optimize-level-2`](https://github.com/mdgriffith/elm-optimize-level-2).

To run a benchmark:

```bash
elm make --optimize src/<Benchmark name>.elm
```

then open `index.html` in your browser. Ideally, you want to run a benchmark in every major browser,
because while a benchmark can show improvements in Chrome, it can show deterioration in Safari for instance.

If you wish to run these benchmarks with [`elm-optimize-level-2`](https://github.com/mdgriffith/elm-optimize-level-2), you can run

```bash
elm-optimize-level-2 src/<Benchmark name>.elm>
```

then open `optimized.html` in your browser.

---

Feel free to share these benchmarks. If you do, please link to this repo
so that others can have a go at changing the benchmarks themselves.

If you find problems in the way some of these benchmarks are done, please open an issue.
