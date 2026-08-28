#!/bin/bash
syllabus=CSCI-39531-Spring-2026
target=$syllabus.tex
pandoc -V documentclass=book -s README.md -o $target
sed -i 's/\\documentclass\[/\\documentclass[openany/g' $target
sed -i 's/]{book}/]{book}\\usepackage[a4paper,margin=0.75in,tmargin=0in,footskip=-0.25in]{geometry}/g' $target
pdflatex $target
rm -f $syllabus.aux $syllabus.log $syllabus.aux $syllabus.tex
