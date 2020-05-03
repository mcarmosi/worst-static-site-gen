# worst-static-site-gen
The world's worst static site generator. Fight me.

## "Design"

A shell script that runs pandoc on everything in sight with options I
like.

## Dependencies

- fish
- pandoc
- yq
- jq

## Magic Files

These filenames are hard-coded, because I am lazy. Run the script in a
directory containing these files, and it'll generate the appropriate
HTML.

- `site.css` : all your css goes here
- `index.template` : [pandoc template](https://pandoc.org/MANUAL.html#templates) for the home page
- `page.template` : [pandoc template](https://pandoc.org/MANUAL.html#templates) for every other page
- `site.yaml` : global metadata and options (nb: not currently implemented)
