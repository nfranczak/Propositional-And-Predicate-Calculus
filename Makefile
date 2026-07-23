SHELL := /bin/bash

UNAME_S := $(shell uname -s)
LATEX   := pdflatex
LATEX_FLAGS := -interaction=nonstopmode -halt-on-error

TEX_FILES := $(shell find . -type f -name '*.tex' -not -path './.git/*')

.PHONY: help setup generate-all generate clean

help:
	@echo "Available targets:"
	@echo "  setup         Install LaTeX toolchain (macOS via Homebrew, Linux via apt/dnf/pacman)."
	@echo "  generate-all  Regenerate every PDF from every .tex file in the repo."
	@echo "  generate      Regenerate one PDF. Usage: make generate FILE=path/to/file.tex"
	@echo "  clean         Remove LaTeX build artifacts (keeps .tex and .pdf)."

setup:
ifeq ($(UNAME_S),Darwin)
	@echo "Detected macOS. Installing LaTeX via Homebrew..."
	@command -v brew >/dev/null 2>&1 || { \
		echo "Homebrew not found. Install it from https://brew.sh/ and re-run 'make setup'."; \
		exit 1; \
	}
	@if ! command -v pdflatex >/dev/null 2>&1; then \
		echo "Installing mactex-no-gui (this is large; may take a while)..."; \
		brew install --cask mactex-no-gui; \
	else \
		echo "pdflatex already installed."; \
	fi
else ifeq ($(UNAME_S),Linux)
	@echo "Detected Linux. Installing LaTeX via the system package manager..."
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get update && \
		sudo apt-get install -y texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-science; \
	elif command -v dnf >/dev/null 2>&1; then \
		sudo dnf install -y texlive-scheme-medium; \
	elif command -v pacman >/dev/null 2>&1; then \
		sudo pacman -S --needed --noconfirm texlive-core texlive-latexextra texlive-fontsextra texlive-science; \
	else \
		echo "No supported package manager found (apt-get, dnf, pacman). Install TeX Live manually."; \
		exit 1; \
	fi
else
	@echo "Unsupported OS: $(UNAME_S). Install TeX Live manually."
	@exit 1
endif
	@echo "Setup complete. Verify with: pdflatex --version"

generate-all:
	@if [ -z "$(TEX_FILES)" ]; then \
		echo "No .tex files found."; \
		exit 0; \
	fi
	@for tex in $(TEX_FILES); do \
		$(MAKE) --no-print-directory generate FILE="$$tex" || exit $$?; \
	done
	@echo "All PDFs regenerated."

generate:
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make generate FILE=path/to/file.tex"; \
		exit 1; \
	fi
	@if [ ! -f "$(FILE)" ]; then \
		echo "File not found: $(FILE)"; \
		exit 1; \
	fi
	@dir=$$(dirname "$(FILE)"); \
	base=$$(basename "$(FILE)"); \
	echo "Building $(FILE)..."; \
	cd "$$dir" && $(LATEX) $(LATEX_FLAGS) "$$base" >/dev/null && \
	$(LATEX) $(LATEX_FLAGS) "$$base" >/dev/null && \
	echo "  -> $$dir/$${base%.tex}.pdf"

clean:
	@find . -type f \( \
		-name '*.aux' -o -name '*.log' -o -name '*.out' -o -name '*.toc' -o \
		-name '*.fls' -o -name '*.fdb_latexmk' -o -name '*.synctex.gz' -o \
		-name '*.nav' -o -name '*.snm' -o -name '*.vrb' -o -name '*.bbl' -o \
		-name '*.blg' \
		\) -not -path './.git/*' -delete
	@echo "Build artifacts removed."
