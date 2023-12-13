library(devtools)
packageVersion("devtools")

#create_package("regexcite")

# Create a git pane
use_git()

# Transfer the function into an R file
use_r("strsplit1")
# If you use RStudio, open R/strsplit1.R in the source editor and put the cursor somewhere in the strsplit1() function definition. Now do Code > Insert roxygen skeleton.

# Loads all functions quickly within the package - make sure to clear global environment of packages before you do this
load_all()

# use the function
(x <- "alfa,bravo,charlie,delta")
strsplit1(x, split = ",")

# The gold standard for checking that an R package is in full working order
check()
# It is essential to actually read the output of the check! Deal with problems early and often.

#License: `use_mit_license()`, `use_gpl3_license()` or friends to pick a license
use_mit_license()

#We still need to trigger the conversion of this new roxygen comment into man/strsplit1.Rd with document():
document()
#document() does two main jobs:

# Converts our roxygen comments into proper R documentation.
# (Re)generates NAMESPACE.

#You should now be able to preview your help file like so:
?strsplit1

# Now that we know we have a minimum viable product, let’s install the regexcite package into your library via install():
install()

# express a concrete expectation about the correct strsplit1() result for a specific input.
use_testthat() # note you have to have the function open in your window for this to work - otherwise specify the name

#Now you can test all your functions using the command below
test()
# Your tests are also run whenever you check() the package. In this way, you basically augment the standard checks with some of your own

# You can declare intent to use certain packages usign the function below
use_package("stringr")

# NOTE: when you call a function from a seperate package, you need to specify in the roxygen documentation that you are inheriting the function, e.g:
# @inheritParams stringr::str_split

# Create a github repository for the package
use_github()

#This function initializes a basic, executable README.Rmd ready for you to edit:
use_readme_rmd()

# Once you have updated the readme RMD, you can use the following:
build_readme()

# on git to stage all
#git add -A
# to commit with a message
#git commit -m “[descriptive message]”
#To push
#git push

