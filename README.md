rgallery: Build a Gallery of R Snippets
-------------

This package makes it easy to create an gallery for displaying small R vignettes, or "snippets". [View an example here!](http://varianceexplained.org/broom-gallery/)

### Installation

Install with [devtools](https://github.com/hadley/devtools):

    devtools::install_github("dgrtwo/rgallery")

You'll need [Jekyll](http://jekyllrb.com/) and [git](http://git-scm.com/) installed as well.

### Usage

To create and edit your gallery, simply:

1. Set up a gallery by running the following commands in R:

        library(rgallery)
        create_gallery("my-gallery")
        build_gallery("my-gallery")

  This downloads the [default r-gallery setup](https://github.com/dgrtwo/rgallery-default) and builds it.

2. Back in the command line, go into the directory and start a Jekyll server:

        cd my-gallery
        jekyll serve --watch

3. Visit your local gallery at [http://127.0.0.1:4000/](http://127.0.0.1:4000/).

4. To create additional snippets, add `.Rmd` files to the `_R` directory. Make sure you include `layout: snippet` in the YAML header. Then do `build_gallery("my-gallery")` to compile them.

5. To publish your gallery online for free, use [GitHub pages](https://pages.github.com/): just make a public repository and push to the `gh-pages` branch. **Note**: You'll need to change the `url` parameter in `_config.yml` to `http://<yourname>.github.io/<repo-name>`.

That's all there is to it!

### Additional customization

You can customize the global knitr options (for example, `cache = TRUE` or `echo = FALSE`) by adding to the `knitr-options` block in `_config.yml`:

    # rgallery options
    knitr-options:
      message: false

### Future Plans

* Categories and tags
* Allowing multiple snippets to be connected, and therefore compiled in a row, to illustrate a larger topic or workflow
* Allowing snippet submission, as a pull request to the repository, directly from R (i.e. `submit_snippet('my_snippet.Rmd', repo = 'dgrtwo/big-gallery')`). Preferably allow the repository owner to build and approve the snippet from within R as well.
* Flexible front-ends, including alternatives to Jekyll
