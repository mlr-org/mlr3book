# latex-math

The notation and shortcuts used in latex-files of lectures, papers, ... of the Working Group Computational Statistics is defined and maintained in this repository. 
Notation & shortcuts are split into multiple files depending on subject and can be integrated as needed. 

+ basic-math: basic mathematical notation such as mathematical spaces, sums & products, linear algebra, basic probability and statistics
+ basic-ml: basic machine learning notation such as notation for data (x, y), prediction functions, likelihood, loss functions, generalization error
+ ml-bagging
+ ml-boosting
+ ml-mbo
+ ml-nn: neural networks
+ ml-svm: support vector machines
+ ml-trees: decision trees

## Using the notation
- Clone this repository into the main directory of your repo.
- Add latex-math to the gitignore file. 
- Add \input{../latex-math/\*}, for every file /\* you need to the preamble of your (TeX/Rmd) file but not into any common preamble file

This means you have to keep this repository in sync with each client repository by also doing git pull in the latex-math subdirectory when pulling changes for the client repo. The reason we do it this way is that work on latex-math is not duplicated.

Note that some of the macros defined here may use additional Latex packages -- a good set to start with is

```
\usepackage{mathtools}
\usepackage{bm} %basic-ml, ml-gp
\usepackage{siunitx} %basic-ml
\usepackage{dsfont} %basic-math
\usepackage{xspace} %ml-mbo
```

See `latex-math.pdf` for all currently defined commands & definitions. 

## Updating / adding files
- A new shortcut / notation that falls into the scope of one of the existing files should be added in the respective file with a short description.
- Multiple shortcuts / notations belonging to another major subject should be summarized in a new .tex file. 
- **ALWAYS** check if a command is already contained in one of the files - overwriting a command might result in compiling errors.  
- **ALWAYS recompile `latex-math.Rmd` if you add new commands so it is kept up-to-date and to check that you have committed all the changes your notation requires to work.**
