# Course: Introduktion til Livets Molekyler

## Pixi installation

The repository is managed using `pixi`, which can be installed from [pixi.prefix.dev](https://pixi.prefix.dev/latest/installation/#__tabbed_1_1) or using the code below (On MacOS/Linux)

```default
curl -fsSL https://pixi.sh/install.sh | sh
```

## Preview

With `pixi` installed the course notes can be previewed locally using the command 

```
pixi r preview
```

Which on first run will install the required dependencies and open a locally-served preview 
of the site. This preview is responsive to changes in any of the relevant documents under `course_notes/`. 

## Layout

The site is created with [Quarto](https://quarto.org/) using Quarto-markdown `.qmd`. 
The layout/structure is 

```default
course_notes
├── _extensions
├── _quarto.yml
├── _site
├── datasets
├── index.qmd
├── python_intro
│  ├── index.qmd
│  ├── python_data_example.qmd
│  ├── python_data_types.qmd
│  ├── python_intro.qmd
│  ├── python_lab_exercise.qmd
│  ├── python_parentheses.qmd
│  └── python_working_with_data.qmd
└── styling
```
Where `_quarto.yml` is the main configuration file and each lesson is a `.qmd`-file in `python_intro/`. Some of the exercises use datasets from the `datasets/`-directory.

`_extensions`, and `styling` are configuration that should not be changed, `_site` is 
the locally rendered version of the site where Quarto markdown has been converted to HTML.

## Editing

Content is written as Quarto markdown that is rendered to HTML. For example the file `course_notes/python_intro/python_intro.qmd` starts with 

```md 
---
title: Getting started
format: 
  live-html:
    toc: true
    number-sections: true
    css: ../styling/styles.css
    theme:
      light: cosmo
      dark: [darkly, ../styling/theme-dark.scss]
    respect-user-color-scheme: true
---

Python is a programming language that is widely used in the scientific community (and for many other things). You will be using Python in various contexts during your studies - ranging from data analysis through plotting to bioinformatics. 

...
```

Where the first part in the `___`-block is YAML front matter (configuration) and the rest is plain text content. Editing the `.qmd`-file will automatically update the preview (when running `pixi r preview`) and once finished can be pushed to GitHub which will re-render the online version of the site immediately. 


In addition to normal Markdown syntax Quarto also supports many extensions 
which is what enables for example interactive Python cells. These are wrapped in "divs" like 

````
```{pyodide}
1 + 2 + 3
```
````

## Git

The repository is version controlled with Git with a remote repository on Github.com. Additionally Github actions are used to build and host the website. To start the repository 
should be cloned locally

```
git clone https://github.com/au-mbg/imol.git
```
This downloads everything to the local machine. On the local machine the repository can then be 
edited. After files have been changed one can run 

```default
git status
```
To see all files that have been changed. Then each file can be added 

```
git add <filename>
```
This will turn them green in the overview given by `git status` and once every file 
that one wants to update has been added a commit is made using 

```
git commit -m "My brief message describing what I did/changed."
```

And finally the changes are pushed to the remote 

```
git push
```
Once pushed Github will automatially re-render the site. 

To get changes pushed by someone else run 

```
git pull
```


