# Propositional-And-Predicate-Calculus

LaTeX source and compiled PDFs of my worked solutions to exercises and theorems
from *Propositional and Predicate Calculus: A Model of Argument* by Derek Goldrei.

## What's in here

Each exercise, theorem, or section has its own directory containing a `.tex`
source file and (once built) its rendered `.pdf`. For example:

```
Propositions-and-Truth-Assignments/
├── exercise2.30/
│   ├── goldrei-exercise2.30.tex
│   └── goldrei-exercise2.30.pdf
├── thm2.2/
│   ├── goldrei-thm2.2.tex
│   └── goldrei-thm2.2.pdf
└── ...
```

Only `.tex` and `.pdf` files are tracked in git; every LaTeX build artifact
(`.aux`, `.log`, `.out`, etc.) is ignored.

## Building the PDFs

A `Makefile` at the repo root drives everything. Run `make help` for the list
of targets.

### One-time setup

Installs a LaTeX toolchain (`pdflatex` + common packages) on macOS or Linux:

```sh
make setup
```

- **macOS**: uses Homebrew to install `mactex-no-gui`.
- **Linux**: uses `apt-get`, `dnf`, or `pacman` to install a TeX Live scheme
  that covers the packages used here (`amsmath`, `amssymb`, `amsthm`,
  `mathrsfs`, `graphicx`).

### Regenerate every PDF

```sh
make generate-all
```

Walks the repo, finds every `.tex` file, and rebuilds its PDF next to it.

### Regenerate one PDF

```sh
make generate FILE=Propositions-and-Truth-Assignments/exercise2.30/goldrei-exercise2.30.tex
```

### Clean up build artifacts

```sh
make clean
```

Removes `.aux`, `.log`, and friends. Leaves `.tex` and `.pdf` alone.
