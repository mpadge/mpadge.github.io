root_files <- c ("package.json", "gulpfile.babel.js")
if (!all (file.exists (root_files)))
    stop ("Must be run from the project root. Use 'make blog'.")

here <- getwd ()
blogdir <- "src/pages/blog"

rmd_files <- fs::dir_ls (blogdir, regexp = "[0-9]{4}.*\\.Rmd$")
md_files  <- fs::dir_ls (blogdir, regexp = "[0-9]{4}.*\\.md$")
md_only   <- md_files [!(fs::path_ext_remove (md_files) %in% fs::path_ext_remove (rmd_files))]
all_entries <- sort (c (rmd_files, md_only))
latest <- utils::tail (all_entries, 1L)

if (fs::path_ext (latest) == "Rmd") {
    md <- fs::path_ext_set (latest, "md")
    setwd (blogdir)
    rmarkdown::render (basename (latest), rmarkdown::md_document (variant = "gfm"))
    setwd (here)
    yaml_str <- yaml::as.yaml (rmarkdown::yaml_front_matter (latest))
    md_body  <- readLines (md)
    writeLines (c ("---", yaml_str, "---", "", md_body), md)
}

source ("tools/blog/update_main.R")
