root_files <- c ("package.json", "gulpfile.babel.js")
if (!all (file.exists (root_files)))
    stop ("Must be run from the project root.")

blog_dir <- "src/pages/blog"

source ("tools/blog/make_entry_xml.R")

blog_data <- yaml::read_yaml ("src/data/blog.yml")

blog_df <- data.frame (
    title       = sapply (blog_data, function (b) b$title),
    description = sapply (blog_data, function (b) b$description),
    link        = sapply (blog_data, function (b) b$link),
    created     = sapply (blog_data, function (b) b$created),
    stringsAsFactors = FALSE
)

f_out <- "src/feed.xml"
generate_rss_feed (blog_df, blog_dir, output_file = f_out)
cli::cli_alert_success ("Updated {f_out}")
