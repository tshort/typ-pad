# simple compile script for generating output for the gh-pages branch
mkdir -p examples/1
mkdir -p examples/2
typst compile --features html --format html example2.typ examples/2/index.html 