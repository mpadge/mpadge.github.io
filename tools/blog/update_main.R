root_files <- c ("package.json", "gulpfile.babel.js")
if (!all (file.exists (root_files)))
    stop ("Must be run from the project root. Use 'make update' or 'make blog'.")

blog_dir <- "src/pages/blog"

source ("tools/blog/make_entry_xml.R")

update_main <- function (n = 6, sort_date = "created")
{
    flist <- order_blog_files (blog_dir, sort_date = sort_date)
    fdat  <- lapply (flist, get_one_blog_dat)

    # blog.yml: full list for the blog index page
    f_out <- "src/data/blog.yml"
    writeLines (format_blog_yaml (fdat), f_out)
    cli::cli_alert_success("Updated {f_out}")

    # blogshort.yml: limited to n most recent entries for the front page
    fdat_short <- if (n < length (fdat)) fdat [seq (n)] else fdat
    f_out <- "src/data/blogshort.yml"
    writeLines (format_blog_yaml (fdat_short, add_blog_prefix = TRUE), f_out)
    cli::cli_alert_success("Updated {f_out}")

    # feed.xml: RSS feed with full content from .md files
    blog_df <- data.frame (
        title       = sapply (fdat, function (f) f$title),
        description = sapply (fdat, function (f) f$description),
        link        = sapply (fdat, function (f) f$link),
        created     = sapply (fdat, function (f) f$date_cre),
        stringsAsFactors = FALSE
    )
    f_out <- "src/feed.xml"
    generate_rss_feed (blog_df, blog_dir, output_file = f_out)
    cli::cli_alert_success("Updated {f_out}")
}

format_blog_yaml <- function (fdat, add_blog_prefix = FALSE)
{
    res <- NULL
    for (f in fdat)
    {
        link <- if (add_blog_prefix) paste0 ("blog/", f$link) else f$link
        upd <- if (!is.null (f$date_upd)) paste0 ("    updated: ", f$date_upd) else NULL
        res <- c (res, "-",
                  paste0 ("    title: ", f$title),
                  paste0 ("    description: ", f$description),
                  paste0 ("    created: ", f$date_cre),
                  upd,
                  paste0 ("    link: ", link))
    }
    return (res)
}

order_blog_files <- function (blog_dir, sort_date = "modified")
{
    lf <- list.files (blog_dir, pattern = "\\.Rmd$", full.names = TRUE)
    if (sort_date == "modified")
        lf [order (file.info (lf)$mtime, decreasing = TRUE)]
    else {
        dates <- vapply (lf, get_date, numeric (1))
        lf [order (dates, decreasing = TRUE)]
    }
}

get_date <- function (rmd)
{
    x     <- readLines (rmd)
    index <- which (x == "---")
    x     <- x [(index [1] + 1):(index [2] - 1)]
    as.numeric (get_datestr (x))
}

get_datestr <- function (x)
{
    date_ln <- x [grep ("^date:", x)]
    as.Date (
        strsplit (date_ln, "date: ") [[1]] [2],
        tryFormats = c (
            "%d/%m/%Y",
            "%d %b %Y",
            "%d %B %Y",
            "%Y-%m-%d"
        )
    )
}

get_one_blog_dat <- function (f)
{
    x     <- readLines (f)
    index <- which (x == "---")
    x     <- x [(index [1] + 1):(index [2] - 1)]

    list (title       = get_title (x),
          description = get_descr (x),
          date_mod    = format (as.Date (file.info (f)$mtime), format = "%d %b %y"),
          date_cre    = format (get_datestr (x), format = "%d %b %y"),
          date_upd    = get_updated (x),
          link        = get_link (x))
}

get_title <- function (x)
{
    tit <- x [grep ("^title:", x)]
    strsplit (tit, "title: ") [[1]] [2]
}

get_descr <- function (x)
{
    dst  <- grep ("^description:", x)
    dend <- grep ("^[a-zA-Z]", x)
    dend <- min (dend [which (dend > dst)]) - 1

    if (dend > dst)
        x <- c (strsplit (x [dst], "^description: ") [[1]] [2],
                x [(dst + 1):dend])
    else
        x <- strsplit (x [dst], "^description: ") [[1]] [2]

    paste0 (trimws (x), collapse = " ")
}

get_updated <- function (x)
{
    idx <- grep ("^updated:", x)
    if (length (idx) == 0) return (NULL)
    d <- strsplit (x [idx], "updated: ") [[1]] [2]
    format (as.Date (d, tryFormats = c ("%d/%m/%Y", "%d %b %Y", "%d %B %Y")),
            format = "%d %b %y")
}

get_link <- function (x)
{
    link <- x [grep ("^link:", x)]
    strsplit (link, "link: ") [[1]] [2]
}

update_main (n = 6, sort_date = "created")
