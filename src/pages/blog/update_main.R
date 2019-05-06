write_blog_entries <- function (n = 6, sort_date = "modified")
{
    flist <- order_blog_files (n = n, sort_date = sort_date)
    fdat <- lapply (flist, function (i) get_one_blog_dat (i))
    
    res <- NULL
    for (f in fdat)
    {
        res <- c (res, "-",
                  paste0 ("    title: ", f$title),
                  paste0 ("    description: ", f$description),
                  paste0 ("    created: ", f$date_cre),
                  paste0 ("    modified: ", f$date_mod),
                  paste0 ("    link: ", f$link))
    }

    fp <- file.path ("..", "..", "data", "blog.yml")
    writeLines (res, fp)
}

order_blog_files <- function (n = 6, sort_date = "modified")
{
    lf <- list.files (".", pattern = "*.Rmd$")
    if (sort_date == "modified")
        flist <- lf [order (file.info (lf)$mtime, decreasing = TRUE)]
    else # sort by creation date
    {
        dates <- do.call (c, lapply (lf, function (i) get_date (i)))
        flist <- lf [order (dates, decreasing = TRUE)]
    }
    flist [seq (min (c (length (flist), n)))]
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
    res <- as.Date (strsplit (date_ln, "date: ") [[1]] [2],
                    tryFormats = c ("%d/%m/%Y", "%d %b %Y"))
    format (res, format = "%d %b %y")
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
          date_cre = get_datestr (x),
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

write_blog_entries (n = 6, sort_date = "modified")
