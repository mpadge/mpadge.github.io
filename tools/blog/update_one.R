root_files <- c ("package.json", "gulpfile.babel.js")
if (!all (file.exists (root_files)))
    stop ("Must be run from the project root. Use 'make blog'.")

here <- getwd ()
blogdir <- "src/pages/blog"
flist <- fs::dir_ls (blogdir, regexp = "[0-9]{4}.*.Rmd$")
f <- utils::tail (flist, 1L)
# Or hard-code different file here ...
setwd (blogdir)
rmarkdown::render (basename (f), rmarkdown::md_document(variant = "gfm"))
setwd (here)
source ("tools/blog/update_main.R")
