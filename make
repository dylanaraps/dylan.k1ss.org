#!/bin/sh -e
#
# Simple static site builder.

page() {
    pp=${page%/*} title=${page##*/} title=${title%%.md}

    mkdir -p "docs/$pp"

    # GENERATION STEP.
    case $page in
        # Generate HTML from txt files.
        *.md)
            < "site/$page" \
            pandoc \
                -f markdown \
                -t html5 \
                --template="$PWD/template.html" \
                --metadata title="dylan araps ${title:+- $title}" |

            sed ':a;N;$!ba;s/>\s*</></g' \
                > "docs/${page%%.md}.html"
        ;;

        # Copy over any non-txt files.
        *)
            cp -f "site/$page" "docs/$page"
        ;;
    esac
}

main() {
    rm -rf docs
    mkdir -p docs

    (cd site && find . -type f) | while read -r page; do
        printf '%s\n' "CC $page"
        page "$page"
    done
}

main "$@"
