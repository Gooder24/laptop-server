# Contributing

Thank you for helping. Please read the accessibility expectations in [ACCESSIBILITY.md](ACCESSIBILITY.md#contributor-expectations) before you open a pull request.

## Checks

```sh
make check                              # shell syntax and the self-test; seconds, no root needed
python3 .github/scripts/check-docs.py   # Markdown headings, image alt text and link text
```

The accessibility workflow runs only the documentation check, on every pull request and on pushes to `main`. Run `make check` yourself.

## Pull requests

Fill in the accessibility checklist in the pull request template. If you add a dependency, say what it does for keyboard and screen reader use.

## Reporting accessibility barriers

Open an issue with the accessibility barrier form, or any plain issue if the form does not work for you. The details are in [ACCESSIBILITY.md](ACCESSIBILITY.md#reporting-accessibility-barriers).

## Good first issues

Issues labelled `good first issue` are small, and each one says what to change and how to know it is done.
