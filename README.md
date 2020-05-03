
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mcq-grab

<!-- badges: start -->

<!-- badges: end -->

The goal of mcq-grab is to extract the MCQ responses from pdf files in
Econ 1101 2020 T1 final.

This will scrape pdfs and using simple pattern matching will extract the
MCQ responses. Critically this code requries the files to be in pdf
format and have typed answers (preferably a single response).

The code will attempt to check responses that are weird and give you
warning in the cell. Even if there is one error I would recommend just
checking all of the student’s responses.

## Instructions

1)  Save your marking template in the folder `template`
2)  Save all your final exams in the folder called `pdfs`. I would
    recommend a mass extract from turn-it-in. The code can handle files
    that are not pdfs (e.g. word documents), they just will be skipped.
3)  Double click `mcq-grab.Rproj`
4)  Open runme.R –\> Hit Ctrl+Shift+Enter
5)  The output should save in your working directory as a file called:
    `mcq_answers.csv`.
6)  CHECK THE OUTPUTS\!\!
7)  You should be able to more or less copy and paste this into the
    marking template.
