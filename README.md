# Misc benchmarks for Elm code

This repository is a collection of benchmarks I created.

To run a benchmark:

```bash
elm make --optimize src/<Benchmark name>.elm
```
then open `index.html` in your browser. Ideally, you want to run a benchmark in every major browser,
because while a benchmark can show improvements in Chrome, it can show deterioration in Safari for instance.

---

Feel free to share these benchmarks. If you do, please link to this repo
so that others can have a go at changing the benchmarks themselves.

If you find problems in the way some of these benchmarks are done, please open an issue.
I don't necessarily aim to maintain these benchmarks, but I'm sure I'd learn something!