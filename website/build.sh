#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

die() {
    echo "$@" >&2
    exit 1
}

rm -rf build
mkdir build

shopt -s nullglob
changelogs=../metadata/en-US/changelogs
files=("$changelogs"/*.txt)
shopt -u nullglob
test ${#files[@]} -gt 0 || die "no changelogs in $changelogs"

latest=$(printf '%s\n' "${files[@]}" | sed 's|.*/||; s|\.txt$||' | sort -rn | head -n1)
version=$(printf '          <span>Version %s</span>' "$latest")

version="$version" awk '
    /<!-- VERSION -->/ { printf "%s\n", ENVIRON["version"]; ver = 1; next }
    { print }
    END {
        if (!ver) { print "no VERSION placeholder in index.html" >"/dev/stderr"; exit 1 }
    }
' index.html >build/index.html
echo "build/index.html"

ua='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36'

font() {
    css=$(set -e; curl -fsS -A "$ua" "https://fonts.googleapis.com/css2?family=$1&display=swap")
    url=$(set -e; awk '/\/\* latin \*\//{f=1} f && /src: url\(/{sub(/.*url\(/, ""); sub(/\).*/, ""); print; exit}' <<<"$css")
    test -n "$url" || die "no latin subset in the google fonts css for $1"
    curl -fsS -o "$2" "$url"
    echo "$2"
}
font 'Roboto:wght@400..700' build/roboto.woff2

icon=../metadata/en-US/images/icon.png
shot=../metadata/en-US/images/phoneScreenshots/1.png
test -f "$icon" || die "missing $icon"
test -f "$shot" || die "missing $shot"

cp "$icon" build/icon.png
echo "build/icon.png"

cp "$shot" build/shot.png
echo "build/shot.png"
