#!/bin/bash

# search key word and replace.
# usage: replace.sh <"keyword"> <"replacement"> <inputfile> [outputfile]
keyword=$1
replacement=$2
sourcefile=$3
targetfile=$4

if [ -z "$4" ]; then
        targetfile="./replaced.out"
fi

if [ -z "$1" -o -z "$2" -o -z "$3" ]; then
        echo 'usage: replace.sh <"keyword"> <"replacement"> <inputfile> [outputfile]'
		exit 1
fi

prefix=$(echo $keyword | awk '{print $1}')
if [ "$prefix" == "$keyword" ]; then
        sed "s/${keyword}/${replacement}/" $sourcefile > $targetfile
else
        sed "
        s/${keyword}/${replacement}/g

        /${prefix}/{
                $b
                N
                h
                s/\( *\)\n/\1/
                t rep
                :rep
                s/${keyword}/${replacement}\n/
                t
                g
        }
        " $sourcefile > $targetfile
fi

