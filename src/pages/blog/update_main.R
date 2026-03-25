update_main <- function (n = 6, sort_date = "created")
{
    source ("make_entry_xml.R")

    flist <- order_blog_files (sort_date = sort_date)
    fdat <- lapply (flist, function (i) get_one_blog_dat (i))

    # Generate HTML content for all blog posts (for RSS feed)
    all_content <- generate_all_blog_content ()

    # Build blog.yml (for blog index page - no content field)
    res <- format_blog_yaml (fdat)
    fp <- file.path ("..", "..", "data", "blog.yml")
    writeLines (res, fp)

    # Build feed_content.yml (for RSS feed - with full HTML content)
    feed_res <- NULL
    for (i in seq_along (fdat))
    {
        f <- fdat [[i]]
        rmd_file <- flist [i]
        content <- all_content [[rmd_file]]
        feed_res <- c (feed_res, "-",
                       paste0 ("    link: ", f$link),
                       paste0 ("    content: '", content, "'"))
    }

    # Generate RSS feed directly (no need for YAML files for feed)
    # Convert fdat to data frame for generate_rss_feed()
    blog_df <- data.frame (
        title = sapply (fdat, function (f) f$title),
        description = sapply (fdat, function (f) f$description),
        link = sapply (fdat, function (f) f$link),
        created = sapply (fdat, function (f) f$date_cre),
        stringsAsFactors = FALSE
    )
    fp_feed_xml <- file.path ("..", "..", "feed.xml")
    generate_rss_feed (blog_df, all_content, output_file = fp_feed_xml)

    # Build blogshort.yml (limited to n entries)
    fdat_short <- if (n < length (fdat)) fdat [seq (n)] else fdat
    res <- format_blog_yaml (fdat_short, add_blog_prefix = TRUE)
    fp <- file.path ("..", "..", "data", "blogshort.yml")
    writeLines (res, fp)
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

order_blog_files <- function (sort_date = "modified")
{
    lf <- list.files (".", pattern = "*.Rmd$")
    if (sort_date == "modified")
        flist <- lf [order (file.info (lf)$mtime, decreasing = TRUE)]
    else # sort by creation date
    {
        dates <- do.call (c, lapply (lf, function (i) get_date (i)))
        flist <- lf [order (dates, decreasing = TRUE)]
    }
    return (flist)
}

get_date <- function (rmd)
{
    con <- file (rmd)
    x <- readLines (con)
    close (con)
    index <- which (x == "---")
    x <- x [(index [1] + 1):(index [2] - 1)]
    get_datestr (x)
}

get_datestr <- function (x)
{
    date_ln <- x [grep ("^date:", x)]
    as.Date (strsplit (date_ln, "date: ") [[1]] [2],
             tryFormats = c ("%d/%m/%Y", "%d %b %Y"))
}

get_one_blog_dat <- function (f)
{
    con <- file (f)
    x <- readLines (con)
    close (con)
    index <- which (x == "---")
    x <- x [(index [1] + 1):(index [2] - 1)]

    date_mod <- format (as.Date (file.info (f)$mtime), format = "%d %b %y")

    list (title = get_title (x),
          description = get_descr (x),
          date_mod = date_mod,
          date_cre = format (get_datestr (x), format = "%d %b %y"),
          link = get_link (x))
}

get_title <- function (x)
{
    tit <- x [grep ("^title:", x)]
    strsplit (tit, "title: ") [[1]] [2]
}

get_descr <- function (x)
{
    dst <- grep ("^description:", x)
    dend <- grep ("^[a-zA-Z]", x)
    dend <- min (dend [which (dend > dst)]) - 1

    if (dend > dst)
        x <- c (strsplit (x [dst], "^description: ") [[1]] [2],
                x [(dst + 1):dend])
    else
        x <- strsplit (x [dst], "^description: ") [[1]] [2]

    x <- gsub ("^[[:space:]]+", "", x)
    paste0 (x, collapse = " ")
}

get_link <- function (x)
{
    link <- x [grep ("^link:", x)]
    strsplit (link, "link: ") [[1]] [2]
}

update_main (n = 6, sort_date = "created")
