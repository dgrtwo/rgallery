rgallery: Build a Gallery of R Snippets
-------------

This package makes it easy to create an gallery for displaying small R vignettes, or "snippets".

### Installation

Install with [devtools](https://github.com/hadley/devtools):

    devtools::install_github("dgrtwo/rgallery")

You'll need [Jekyll](http://jekyllrb.com/) installed as well.

### Usage

To create and edit your gallery, simply:

1. Clone the default repository and enter the directory:

      git clone https://github.com/dgrtwo/rgallery-default.git my-gallery
      cd my-gallery

2. Start a Jekyll server:

      jekyll serve --watch

3. Visit your local gallery at [http://127.0.0.1:4000/](http://127.0.0.1:4000/).

4. To create additional snippets, add `.Rmd` files to the `_R` directory. Make sure you include `layout: snippet` in the YAML header.

5. To build (or re-build) your new snippets, go into R and run:

      rgallery::build_gallery()

6. To publish your gallery online for free, use [GitHub pages](https://pages.github.com/): just make a public repository and push to the `gh_pages` branch.

That's all there is to it!

### Future Plans

* Categories and tags, allowing multiple snippets to be connected to illustrate a larger topic or workflow
* Allowing snippet submission, as a pull request to the repository, directly from R (i.e. `submit_snippet('my_snippet.Rmd', repo = 'dgrtwo/big-gallery')`). Preferably allow the repository owner to build and approve the snippet from within R as well.
* Flexible front-ends, including alternatives to Jekyll
