set shell := ["bash", "-euo", "pipefail", "-c"]

# Default recipe
default: build

# Compile every non-empty .typ file into a PDF
build:
    #!/usr/bin/env bash
    find . -maxdepth 1 -type f -name '*.typ' -size +0c -print0 |
        while IFS= read -r -d '' file; do
            echo "==> Compiling: $file"
            typst compile "$file" "${file%.typ}.pdf"
        done

# Remove generated PDFs
clean:
    rm -f -- *.pdf
