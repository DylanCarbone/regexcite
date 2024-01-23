#To setup your package to use testthat, run:

usethis::use_testthat(3)

#This:

#1. Create a tests/testthat/ directory.
#2. Add testthat to the Suggests field in the DESCRIPTION and specify testthat 3e in the Config/testthat/edition field.
#3. Create a file tests/testthat.R that runs all your tests when R CMD check runs (Section 4.5).

# NOTE: Do not edit tests/testthat.R! It is run during R CMD check (and, therefore, devtools::check()), but is not used in most other test-running scenarios (such as devtools::test() or devtools::test_active_file())

# names must begin with 'test`.

# usethis offers a helpful pair of functions for creating or toggling between files:

use_r("foofy")    # creates and opens R/foofy.R
use_test("blarg") # creates and opens tests/testthat/test-blarg.R

#Either one can be called with a file (base) name, in order to create a file and open it for editing:

# You can additionally use use_test(), specifying the function, or having it open in the page, and it will create a new test file and provide you with an example test.

# Reload the functions after making tweaks
#devtools::load_all() # Note that this will not work when the function has no content, so it has been commented out for this tutorial

# run the test for a single file
#testthat::test_file("tests/testthat/test-foofy.R")

# Macro-iteration: As you near the completion of a new feature or bug fix, you will want to run the entire test suite.
# Most frequently, you’ll do this with devtools::test():
devtools::test()

# eventually you can check all functions and tests
#devtools::check()

#NOTE you should include library calls! All of the functions from packages should be called with "::"
################
library(testthat)
library(stringr)
local_edition(3)
##################

#chain tests inside a test_that function
# desc paramater, here "basic duplication works", is a human readible title to be observed at the top of error report
test_that("basic duplication works", {
  expect_equal(str_dup("a", 3), "aaa")
  expect_equal(str_dup("abc", 2), "abcabc")
  expect_equal(str_dup(c("a", "b"), 2), c("aa", "bb"))
  expect_equal(str_dup(c("a", "b"), c(2, 3)), c("aa", "bbb"))
})

test_that("0 duplicates equals empty string", {
  expect_equal(str_dup("a", 0), "")
  expect_equal(str_dup(c("a", "b"), 0), rep("", 2))
})

# Test for an expected error
# Note the class parameter, which accepts only a specific error message
test_that("uses tidyverse recycling rules", {
  expect_error(str_dup(1:2, 1:3), class = "vctrs_error_incompatible_size")
})

1 / "a"
expect_error(1 / "a")

#Likewise, you can test for an expected warning
log(-1)
expect_warning(log(-1))

# The challenge about testing for any error is that it accepts ANY error.
# For example, in the below example, str_dup is spelt wrong.
expect_error(str_duq(1:2, 1:3))
str_duq(1:2, 1:3)

#Historically, the best defense against this was to assert that the condition message matches a certain regular expression, via the second argument, regexp.
expect_error(1 / "a", "non-numeric argument")
expect_warning(log(-1), "NaNs produced")

# This does reveal spelling mestake errors
expect_error(str_duq(1:2, 1:3), "recycle")

#Recent developments in both base R and rlang make it increasingly likely that conditions are signaled with a class, which provides a better basis for creating precise expectations.
# fails, error has wrong class
expect_error(str_duq(1:2, 1:3), class = "vctrs_error_incompatible_size")

# passes, error has expected class
expect_error(str_dup(1:2, 1:3), class = "vctrs_error_incompatible_size")
# If you have the choice, express your expectation in terms of the condition’s class, instead of its message.

# Use this if you just want no error
expect_no_error(1 / 2)

# Snapshot tests
# Waldo can be used as part of a snapshot test to see if differences in outputs are reported to users in the intended way
# waldo is designed to compare complex R objects and identify and explain any differences.
withr::with_options(
  list(width = 20),
  waldo::compare(c("X", letters), c(letters, "X"))
)
# The two primary inputs differ at two locations: once at the start and once at the end.

# Take this example...
test_that("side-by-side diffs work", {
  withr::local_options(width = 20)
  expect_snapshot(
    waldo::compare(c("X", letters), c(letters, "X"))
  )
})
# the expect_snapshot function can ONLY be ran as part of test that, not directly from the console. So if you try to run the code below, It will produce the message "Can't compare snapshot to reference when testing interactively."
expect_snapshot()

# but when placed inside a test, it will generate a snapshot.
devtools::test()
# The first time this was ran, it generated a new snapshot
# The snapshot is added to tests/testthat/_snaps/diff.md

# expect_match(object, regexp, ...) matches a character vector input against a regular expression regexp
string <- "Testing is fun!"

expect_match(string, "Testing")

# Fails, match is case-sensitive
expect_match(string, "testing")

# Passes because additional arguments are passed to grepl():
expect_match(string, "testing", ignore.case = TRUE)

#expect_setequal(x, y) tests that every element of x occurs in y, and that every element of y occurs in x. But it won’t fail if x and y happen to have their elements in a different order.

#expect_length(object, n) is a shortcut for expect_equal(length(object), n).

# expect_s3_class() and expect_s4_class() check that an object inherit()s from a specified class.
model <- lm(mpg ~ wt, data = mtcars)
expect_s3_class(model, "lm")
expect_s3_class(model, "glm")

### Designing a test suite

# Note that Test suites should not include library calls
######################
library(testthat)
local_edition(3)
#####################

# Tips:
# Strive to test each behaviour in one and only one test. Then if that behaviour later changes you only need to update a single test.
# Focus on testing the external interface to your functions
# Always write a test when you discover a bug. You may find it helpful to adopt the test-first philosophy. There you always start by writing the tests, and then write the code that makes them pass.

# Test coverage
#In some technical sense, 100% test coverage is the goal, however, this is rarely achieved in practice and that’s often OK. Going from 90% or 99% coverage to 100% is not always the best use of your development time and energy. In many cases, that last 10% or 1% often requires some awkward gymnastics to cover. Sometimes this forces you to introduce mocking or some other new complexity. Don’t sacrifice the maintainability of your test suite in the name of covering some weird edge case that hasn’t yet proven to be a problem.

# Covr is used interactively, for exploring the coverage of an individual file or the whole package, or through Automatic, remote use via GitHub Actions (GHA)

# GitHub Actions (GHA)

# We cover continuous integration and GHA more thoroughly in Chapter 20, but we will at least mention here that usethis::use_github_action("test-coverage") configures a GHA workflow that constantly monitors your test coverage. Test coverage can be an especially helpful metric when evaluating a pull request (either your own or from an external contributor).

# Writing good tests for a code base often feels more challenging than writing the code in the first place.

# note the advice provided aren't hard and fast rules, but are, rather, guidelines. There will always be specific situations where it makes sense to bend the rule.

# Within Test that, objects created inside the curly brackets are deteled, unless they are library calls or configure other aspects such as the view size. If you have to tweak these variables, for example by calling console list, you can use the command, waldo.

# We recommend including withr in Suggests

# An example of the problem is shown below:
# grep("jsonlite", search(), value = TRUE)
# getOption("opt_whatever")
# Sys.getenv("envvar_whatever")
#
# test_that("landscape changes leak outside the test", {
#   library(jsonlite)
#   options(opt_whatever = "whatever")
#   Sys.setenv(envvar_whatever = "whatever")
#
#   expect_match(search(), "jsonlite", all = FALSE)
#   expect_equal(getOption("opt_whatever"), "whatever")
#   expect_equal(Sys.getenv("envvar_whatever"), "whatever")
# })
#
# grep("jsonlite", search(), value = TRUE)
# getOption("opt_whatever")
# Sys.getenv("envvar_whatever")

# And the Withr solution

# grep("jsonlite", search(), value = TRUE)
# #> character(0)
# getOption("opt_whatever")
# #> NULL
# Sys.getenv("envvar_whatever")
# #> [1] ""
#
# test_that("withr makes landscape changes local to a test", {
#   withr::local_package("jsonlite")
#   withr::local_options(opt_whatever = "whatever")
#   withr::local_envvar(envvar_whatever = "whatever")
#
#   expect_match(search(), "jsonlite", all = FALSE)
#   expect_equal(getOption("opt_whatever"), "whatever")
#   expect_equal(Sys.getenv("envvar_whatever"), "whatever")
# })
# #> Test passed
#
# grep("jsonlite", search(), value = TRUE)
# #> character(0)
# getOption("opt_whatever")
# #> NULL
# Sys.getenv("envvar_whatever")
# #> [1] ""


# testthat leans heavily on withr to make test execution environments as reproducible and self-contained as possible.
# in testthat 3e, the local_reproducible_output() function temporarily sets various options and environment variables to values favorable for testing

test_that("something specific happens", {
  local_reproducible_output() # <-- this happens implicitly

  # your test code, which might be sensitive to ambient conditions, such as
  # display width or the number of supported colors
})

#it suppresses colored output, turns off fancy quotes, sets the console width, and sets LC_COLLATE = "C". Usually, you can just passively enjoy the benefits of local_reproducible_output(). But you may want to call it explicitly when replicating test results interactively or if you want to override the default settings in a specific test.

# Remember that tests are often revisited only when something breaks. When you are called to fix a broken test that you have never seen before, you will be thankful someone took the time to make it easy to understand. Code is read far more than it is written, so make sure you write the test you’d like to read!

# A BAD example of a test that is difficult to troubleshoot
# dozens or hundreds of lines of top-level code, interspersed with other tests,
# which you must read and selectively execute
# test_that("f() works", {
#   x <- function_from_some_dependency(object_with_unknown_origin)
#   expect_equal(f(x), 2.5)
# })

#This test is much easier to drop in on if dependencies are invoked in the normal way, i.e. via ::, and test objects are created inline:

# dozens or hundreds of lines of self-sufficient, self-contained tests,
# all of which you can safely ignore!

# test_that("f() works", {
#   useful_thing <- ...
#   x <- somePkg::someFunction(useful_thing)
#   expect_equal(f(x), 2.5)
# })
# NOTE: the key change above is that we are not calling a mysterious object, but instead a dataset which has been created transparently.
# One obvious consequence of our suggestion to minimize code with “file scope” is that your tests will probably have some repetition. And that’s OK!

# for example:
test_that("multiplication works", {
  useful_thing <- 3
  expect_equal(2 * useful_thing, 6)
})
#> Test passed

test_that("subtraction works", {
  useful_thing <- 3
  expect_equal(5 - useful_thing, 2)
})
#> Test passed

# Your test code will be executed in two different settings:
# Interactive test development and maintenance
# Automated test runs, which is accomplished with functions - the most important.

# The functions and other objects defined by your package are always available when testing, regardless of whether they are exported or not. For interactive work, devtools::load_all() takes care of this. During automated testing, this is taken care of internally by testthat.

# Inside the testthat.R file, it runs a series of tests using the test_check() function. It is recommended that you do not modify it manually.

# Helper files are files below the testthat folder that begin with helper. When creating helper files, use the naming convention helper-function_of_interest.R

# There are helpers that check whether the active project has specific files.

# There are additionally setup files, defined as files below testthat that begin with setup-
# setup files are good for global testing tailored to execution in non interactive or remote envs. These files WILL NOT SHOW in contiunous integration. Usage examples include messaging aimed at the interactive user.

# You can additionally store data in test that. Note testthat will only run scripts starting with "helper", "setup" or "test".

# You can use the function test_path() to read test rds files, as it will always search the testthat directory. An example of its application is seen below:
# test_that("foofy() does this", {
#   useful_thing <- readRDS(test_path("fixtures", "useful_thing1.rds"))
#   # ...
# })

# Say you have to create a temporary file as a component of a test, but want the file to be deleted afterwards. You can use the function, withr::local_tempfile() to create a temporary file, and delete it at the end of the test. See the example below:
test_that("can read from file name with utf-8 path", {
  path <- withr::local_tempfile(
    pattern = "Universit\u00e0-",
    lines = c("#' @include foo.R", NULL)
  )
  expect_equal(find_includes(path), "foo.R")
})

# In more extensive situations, you can also use withr to create local folders


















