#!/bin/bash
# Not sure about the relative advantages of tidy or xmllint.
xsltproc --html $1 $2 | tidy -q
