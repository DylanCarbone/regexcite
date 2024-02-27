# They recommend using an integrated development environment (IDE). In Section 4.2 we encouraged the use of the RStudio IDE for package development work. That’s what we document, since it’s what we use and devtools is developed to work especially well with RStudio. But even if it’s not RStudio, we strongly recommend working with an IDE that has specific support for R and R package development.

#Continuous integration and deployment, a.k.a. CI/CD (or even just CI): This terminology comes from the general software engineering world and can sound somewhat grandiose or intimidating when applied to your personal R package. All this really means is that you set up specific package development tasks to happen automatically when you push new work to your hosted repository.

#  The easiest way to start using CI use github's companion service, GitHub Actions (GHA).

# Github actions, should, above all else, be used to run R CMD check.
# if you call usethis::use_github_action(), cou can choose from the most useful workflows.
use_github_action()

# 1: check-standard: Run `R CMD check` on Linux, macOS, and Windows
# 2: test-coverage: Compute test coverage and report to https://about.codecov.io
# 3: pr-commands: Add /document and /style commands for pull requests
#
# Selection:

# Of the following options, 1 is recommended, especially for packages that aspire to be on CRAN. This runs R CMD check across combinations of operating systems and R versions

# If you run option 1, you will see messages along the following lines:
#> ✔ Creating '.github/'
#> ✔ Adding '*.html' to '.github/.gitignore'
#> ✔ Creating '.github/workflows/'
#> ✔ Saving 'r-lib/actions/examples/check-standard.yaml@v2' to .github/workflows/R-CMD-check.yaml'
#> • Learn more at <https://github.com/r-lib/actions/blob/v2/examples/README.md>.
#> ✔ Adding R-CMD-check badge to 'README.md'

# A new GHA workflow file is written to .github/workflows/R-CMD-check.yaml. GHA workflows are specified via YAML files. The message reveals the source of the YAML and gives a link to learn more.

# usethis also adds a badge to the read me file reporting the RCMD check.

# The usethis::use_github_action() function also gives you access to pre-made workflows. You can use these to configure any of the example workflows in r-lib/actions by passing the workflow’s name. For example:
use_github_action("test-coverage") #  configures a workflow to track the test coverage of your package, as described in Section 14.1.1.











