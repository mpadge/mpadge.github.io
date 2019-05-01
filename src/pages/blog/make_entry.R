blog_render <- function (fname, center_images = TRUE) {
    rmarkdown::render(paste0 (fname, ".Rmd"),
                      rmarkdown::md_document(variant='gfm'))
    file.rename (paste0 (fname, ".md"), paste0 (fname, ".html"))
    conn <- file (paste0 (fname, ".html"))
    md <- readLines (conn)
    #yaml_end <- which (md == "---") [2]
    #yaml <- md [1:yaml_end]
    ##md <- md [(yaml_end + 1):length (md)]
    yaml <- NULL
    
    # a few necessary replacements:
    md [md == "```{r}"] <- md [md == "``` {r}"] <- "``` r"
    md <- gsub ("{{#", "&#123;&#123;&#35;", md, fixed = TRUE)
    md <- gsub ("{{ #", "&#123;&#123; &#35;", md, fixed = TRUE)
    md <- gsub ("{{", "&#123;&#123;", md, fixed = TRUE)
    md <- gsub ("}}", "&#125;&#125;", md, fixed = TRUE)

    # move image files
    path <- file.path (paste0 (fname, "_files"), "figure-gfm")
    flist <- list.files (path, full.names = TRUE)
    newpath <- file.path ("..", "..", "assets", "img", fname)
    if (!dir.exists (newpath))
        dir.create (newpath, recursive = TRUE)
    file.rename (flist, file.path (newpath, list.files (path)))
    unlink (paste0 (fname, "_files"), recursive = TRUE)

    # and change image location to newpath:
    md <- gsub (path, newpath, md)
    if (center_images)
    {
        index <- grep (newpath, md)
        n <- length (index)
        # copy each of those lines both above and below:
        md <- md [sort (c (seq (md), rep (index, each = 2)))]
        index <- grep (newpath, md)
        # get the index to the middle of each group of 3 repeats:
        index <- index [3 * 1:n - 1]
        md [index - 1] <- "<center>"
        md [index + 1] <- "</center>"
    }

    # add links to headers
    hdrs <- find_headers (md)
    toc <- write_toc (hdrs)

    md <- process_headers (md, 1)
    md <- process_headers (md, 2)
    md <- process_headers (md, 3)

    # The sidebar with links to header elements

    # the foundation html header and footer:
    header <- c ('{{> header}}',
                 '{{> blog_entry_header}}',
                 toc,
                 '<div class="cell medium-11 large-11">',
                 '{{#markdown}}')
    footer <- c ('{{/markdown}}',
                 '</div>')
    md <- c (yaml, header, md, footer)
    writeLines (md, conn)
    close (conn)
}

find_headers <- function (md)
{
    ptn <- paste0 ("^", paste0 (rep ("\\#", level), collapse = ""))
    hdrs <- gsub ("\\#+ ", "", md [grep (ptn, md)])
    hdrs_link <- gsub ("[[:space:]]+|[[:punct:]]+", "-", hdrs)
    hdrs_link <- gsub ("-+", "-", hdrs_link)
    
    cbind (hdrs, hdrs_link)
}

write_toc <- function (hdrs)
{
    res <- c ("", paste0 ('<div class="cell small-1 medium-1 large-1 left"',
                      'data-sticky-container>'),
              '<div class="sticky" data-sticky data-margin-top="10">')
    for (h in seq (nrow (hdrs)))
        res <- c (res, paste0 ('<a href="#', hdrs [h, 2],
                               '" style="color:#111111">', hdrs [h, 1],
                               '</a><br><br>'))
    c (res, '</div>', '</div>', "")
}

process_headers <- function (md, level = 1)
{
    ptn <- paste0 ("^", paste0 (rep ("\\#", level), collapse = ""), " ")
    hdrs <- grep (ptn, md)
    repl <- paste0 (paste0 (rep ("#", level), collapse = ""), " ")
    for (h in hdrs)
    {
        hdr <- gsub (repl, "", md [h])
        nm <- gsub ("[[:space:]]+|[[:punct:]]+", "-", hdr)
        nm <- gsub ("-+", "-", nm)
        md [h] <- paste0 ('<h', level, '><a name="', nm,
                          '" style = "color:#111111;">', hdr, '</a></h',
                          level, '>')
    }
    return (md)
}
blog_render ("blog01")
