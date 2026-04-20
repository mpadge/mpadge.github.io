# Resolve project root from this script's own location, not from getwd(),
# so the script works whether called from the project root or src/pages/blog/.
script_dir    <- dirname (normalizePath (sys.frame (1)$ofile))
project_root  <- normalizePath (file.path (script_dir, "..", ".."))
blog_dir      <- file.path (project_root, "src", "pages", "blog")

source (file.path (script_dir, "make_entry_xml.R"))

update_main <- function (n = 6, sort_date = "created")
{
    flist <- order_blog_files (blog_dir, sort_date = sort_date)
    fdat  <- lapply (flist, get_one_blog_dat)

    # blog.yml: full list for the blog index page
    writeLines (format_blog_yaml (fdat),
                file.path (project_root, "src", "data", "blog.yml"))

    # blogshort.yml: limited to n most recent entries for the front page
    fdat_short <- if (n < length (fdat)) fdat [seq (n)] else fdat
    writeLines (format_blog_yaml (fdat_short, add_blog_prefix = TRUE),
                file.path (project_root, "src", "data", "blogshort.yml"))

    # feed.xml: RSS feed with full content from .md files
    blog_df <- data.frame (
        title       = sapply (fdat, function (f) f$title),
        description = sapply (fdat, function (f) f$description),
        link        = sapply (fdat, function (f) f$link),
        created     = sapply (fdat, function (f) f$date_cre),
        stringsAsFactors = FALSE
    )
    generate_rss_feed (blog_df, blog_dir,
                       output_file = file.path (project_root, "src", "feed.xml"))
}

format_blog_yaml <- function (fdat, add_blog_prefix = FALSE)
{
    res <- NULL
    for (f in fdat)
    {
        link <- if (add_blog_prefix) paste0 ("blog/", f$link) else f$link
        res <- c (res, "-",
                  paste0 ("    title: ", f$title),
                  paste0 ("    description: ", f$description),
                  paste0 ("    created: ", f$date_cre),
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
    as.Date (strsplit (date_ln, "date: ") [[1]] [2],
             tryFormats = c ("%d/%m/%Y", "%d %b %Y", "%d %B %Y"))
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

get_link <- function (x)
{
    link <- x [grep ("^link:", x)]
    strsplit (link, "link: ") [[1]] [2]
}

update_main (n = 6, sort_date = "created")
