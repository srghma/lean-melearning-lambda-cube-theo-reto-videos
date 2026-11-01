set shell := ["bash", "-euo", "pipefail", "-c"]

default: build

# Format and compile outdated PDFs
build:
    #!/usr/bin/env bash
    find . -maxdepth 1 -type f -name '*.typ' -size +0c -print0 |
        while IFS= read -r -d '' file; do
            pdf="${file%.typ}.pdf"

            echo "==> Formatting: $file"
            typstyle -i "$file"

            if [[ ! -f "$pdf" || "$file" -nt "$pdf" ]]; then
                echo "==> Compiling: $file"
                typst compile "$file" "$pdf"
            else
                echo "==> Up to date: $pdf"
            fi
        done

# Remove generated PDFs
clean:
    rm -f -- *.pdf
