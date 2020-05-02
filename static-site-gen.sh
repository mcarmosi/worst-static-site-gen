#! /usr/local/bin/fish

for i in (find . -name \*.md -type f)
    echo (dirname $i)/(basename $i .md).html
    pandoc -s -o (dirname $i)/(basename $i .md).html $i
end

function ytojs
    # slice out YAML front-matter, convert to JSON
    sed '1d; /---/q' $argv | sed '$d' | read -z yaml
    echo $yaml | yq r -j /dev/stdin
end

function tocgather
    echo '{ "article": [] }' >toc.json
    for i in (find articles -name \*.md -type f)[-1..1]
	set target (basename $i .md).html
	ytojs $i | jq ".file = \"$target\"" | read -z jsonblob
	cat toc.json | jq ".article += [$jsonblob]" | read -z toci
	echo $toci >toc.json
    end
end

function tocbuild
    pandoc --template index.template \
    --metadata-file toc.json --css site.css -o index.html index.md 
end

tocgather
tocbuild

# blog.json is where "global variables" go
# nb: currently there is no blog.json

# site.css is where the css goes

# index.template is the template for "index" pages

# page.template is the template for every other page

# Possible Features: more than one "category" of articles, IE,
# root-level documents end up in the top-level navigation, and
# documents in folders get their own "automatic" index.

# set $dirs (find . -maxdepth 1 -type d)
