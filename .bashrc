
# Takes a DOI input and creates a bibtex entry 
doi2bib () {
	#!/bin/bash

# Author: Conner McDaniel
# https://github.com/connermcd/bin
# MIT license

set -e

result=
i=
while [[ $i < 10 && "$result" != *"author = "* ]]; do
    result=$(curl -s "http://api.crossref.org/works/$1/transform/application/x-bibtex")
    i=$(( $i + 1 ))
done
echo "$result"
}


# Takes a pdf file input and outputs a DOI
pdf2doi () {
	#!/bin/bash

# Author: Conner McDaniel
# https://github.com/connermcd/bin
# MIT license

set -e

pdftotext "$1" - | grep -oP "\b(10[.][0-9]{4,}(?:[.][0-9]+)*/(?:(?![\"&\'<>])\S)+)\b" | head -n 1

}


# Takes a pdf file name, finds the doi, creates a .md file with the same name as the pdf to take notes on
notate_paper () {
#!/bin/bash

# Author: Conner McDaniel
# https://github.com/connermcd/bin
# MIT license

set -e

pdf="$1"
doi="$(pdf2doi ${1})"
bib=$(curl -s "http://api.crossref.org/works/$doi/transform/application/x-bibtex")
title=$(echo "$bib" | sed -n '1p' | cut -d{ -f2 | sed 's/,//')
file_name=

make_file() {
new_pdf="$(dirname $pdf)/$1.pdf"
[[ ! -f "$new_pdf" ]] && mv "$pdf" "$new_pdf"
bib=$(echo "$bib" | sed "1a\\\tpdf = {$new_pdf},")
cat >"$file_name" <<EOF
---
title: $title Notes
author: Nathan Quan
csl: /home/nathan/.csl/
---
~~~.bib
$bib
~~~
# Summary

# Quotes and Data

# Questions

EOF
}

check_file() {
    file="$HOME/Documents/Notes/Papers/$1.md"
    if [[ -f $file ]]; then
        file_doi=$(jrep -o -E "doi = {[^}]*" $file | cut -d{ -f2)
        if [[ "${file_doi,,}" =~ "${doi,,}" ]]; then
            file_name="$file"
        else
            check_file "${1}+"
        fi
    else
        file_name="$file"
        make_file "$1"
    fi
}

check_file "$title"
vim "$file_name"
}


# Takes a pdf file name, finds the doi, creates a .md file with the same name as the pdf to take notes on
notate_book () {
#!/bin/bash

# Author: Conner McDaniel
# https://github.com/connermcd/bin
# MIT license

set -e

pdf="$1"
doi="$(pdf2doi ${1})"
bib=$(curl -s "http://api.crossref.org/works/$doi/transform/application/x-bibtex")
title=$(echo "$bib" | sed -n '1p' | cut -d{ -f2 | sed 's/,//')
file_name=

make_file() {
new_pdf="$(dirname $pdf)/$1.pdf"
[[ ! -f "$new_pdf" ]] && mv "$pdf" "$new_pdf"
bib=$(echo "$bib" | sed "1a\\\tpdf = {$new_pdf},")
cat >"$file_name" <<EOF
---
title: $title Notes
author: Nathan Quan
csl: /home/nathan/.csl/
---
~~~.bib
$bib
~~~
# Summary

# Quotes and Data

# Questions

EOF
}

check_file() {
    file="$HOME/Documents/Notes/Books/$1.md"
    if [[ -f $file ]]; then
        file_doi=$(jrep -o -E "doi = {[^}]*" $file | cut -d{ -f2)
        if [[ "${file_doi,,}" =~ "${doi,,}" ]]; then
            file_name="$file"
        else
            check_file "${1}+"
        fi
    else
        file_name="$file"
        make_file "$1"
    fi
}

check_file "$title"
vim "$file_name"
}

# Takes a pdf file name, finds the doi, creates a .md file with the same name as the pdf to take notes on
notate_textbook () {
#!/bin/bash

# Author: Conner McDaniel
# https://github.com/connermcd/bin
# MIT license

set -e

pdf="$1"
doi="$(pdf2doi ${1})"
bib=$(curl -s "http://api.crossref.org/works/$doi/transform/application/x-bibtex")
title=$(echo "$bib" | sed -n '1p' | cut -d{ -f2 | sed 's/,//')
file_name=

make_file() {
new_pdf="$(dirname $pdf)/$1.pdf"
[[ ! -f "$new_pdf" ]] && mv "$pdf" "$new_pdf"
bib=$(echo "$bib" | sed "1a\\\tpdf = {$new_pdf},")
cat >"$file_name" <<EOF
---
title: $title Notes
author: Nathan Quan
csl: /home/nathan/.csl/
---
~~~.bib
$bib
~~~
# Summary

# Quotes and Data

# Questions

EOF
}

check_file() {
    file="$HOME/Documents/Notes/Textbooks/$1.md"
    if [[ -f $file ]]; then
        file_doi=$(jrep -o -E "doi = {[^}]*" $file | cut -d{ -f2)
        if [[ "${file_doi,,}" =~ "${doi,,}" ]]; then
            file_name="$file"
        else
            check_file "${1}+"
        fi
    else
        file_name="$file"
        make_file "$1"
    fi
}

check_file "$title"
vim "$file_name"
}

# Look for tags in the .bib file in the Notes dir and places them in the tags file. Also greps for any pdf with bibtex header in the .bib file
notetags() {
#!/bin/bash

# Author: Conner McDaniel
# https://github.com/connermcd/bin
# MIT license

set -e

cd $HOME/Documents/Notes/

[[ -f tags ]] && rm tags
grep --exclude="*.bib" -r "tags = {" * | while read line; do
    file=$(echo "$line" | cut -d: -f1)
    unparsed_tags=$(echo "$line" | cut -d: -f2)
    tags=$(echo $unparsed_tags | sed -e "s/tags = {//g" -e "s/,\|}//g")
    for tag in $tags; do
        echo "$tag	$file	/^$unparsed_tags$/;" >> tags
    done
done

[[ -f global.bib ]] && rm global.bib
pcregrep -r -h -M -I --exclude-dir=img --exclude=".*pdf" "^@(\n|.)*~~~" . > global.bib
}




