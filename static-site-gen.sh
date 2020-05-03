#!/usr/bin/env fish

function out_file
    echo (dirname $argv)/(basename $argv .md).html
end

function pandoc_everything
    for i in (find . -name \*.md -type f)
	echo (out_file $i)
	if test (dirname $i) = '.'
	    pandoc --css site.css -s -o (out_file $i) $i
	else
	    pandoc --css ../site.css -s -o (out_file $i) $i
	end
    end
end

function ytojs
    # slice out YAML front-matter, convert to JSON
    sed '1d; /---/q' $argv | sed '$d' | yq r -j /dev/stdin
end

function toc_gather
    echo '{ "article": [] }' >toc.json
    for i in (find articles -name \*.md -type f)[-1..1]
	ytojs $i | jq '.file = "'(out_file $i)'"' | read -z jsonblob
	string collect (cat toc.json | jq ".article += [$jsonblob]") > toc.json
    end
end

function toc_build
    pandoc --template index.template \
    --metadata-file toc.json --css site.css -o index.html index.md 
end

pandoc_everything
toc_gather
toc_build


## echo "$(sort your_file)" > your_file
# above: a one-liner to modify files in place

# actually what is probably better
# function get_blob
#     ytojs $argv[0] | jq ".file = \"$argv[1]\""
# end


# blog.json is where "global variables" go
# nb: currently there is no blog.json

# site.css is where the css goes

# index.template is the template for "index" pages

# page.template is the template for every other page

# Possible Features: more than one "category" of articles, IE,
# root-level documents end up in the top-level navigation, and
# documents in folders get their own "automatic" index.

# set $dirs (find . -maxdepth 1 -type d)
