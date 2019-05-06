blog_render <- function (fname, centre_images = TRUE) {
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

    md <- move_image_files (md, fname, centre_images = TRUE,
                            rmd_fig_dir = "figure-gfm",
                            dest_dir = c ("assets", "img"))

    # add links to headers
    hdrs <- find_headers (md)
    toc <- write_toc (hdrs)

    md <- process_headers (md, 1)
    md <- process_headers (md, 2)
    md <- process_headers (md, 3)

    # the foundation html header and footer:
    header <- c ('{{> header}}',
                 '{{> blog_entry_header}}',
                 toc,
                 '<div class="cell small-10 medium-10 large-10">',
                 '<div class="sections">',
                 '{{#markdown}}')
    footer <- c ('<div style="text-align: right">',
                 paste ('Originally posted:', Sys.Date()),
                 paste ('Updated:', Sys.Date()),
                 '</div>',
                 '{{/markdown}}',
                 '</div>',
                 '</div>',
                 '{{> blog_entry_footer}}')
    md <- c (yaml, header, md, footer)
    writeLines (md, conn)
    close (conn)
}

find_headers <- function (md)
{
    hdrs <- gsub ("\\#+ ", "", md [grep ("^\\#+", md)])
    hdrs_link <- gsub ("[[:space:]]+|[[:punct:]]+", "-", hdrs)
    hdrs_link <- gsub ("-+", "-", hdrs_link)
    
    cbind (hdrs, hdrs_link)
}

write_toc <- function (hdrs)
{
    res <- c ("",
              '<div class="cell small-2 medium-2 large-2 left">',
              '<nav class="sticky-container" data-sticky-container>',
              paste0 ('<div class="sticky" data-sticky data-anchor=',
                      '"how-i-make-this-site" data-sticky-on="large"',
                      ' data-margin-top="5">'),
              '<ul class="vertical menu" data-magellan>')

    for (h in seq (nrow (hdrs)))
        res <- c (res, paste0 ('<li><a href="#', hdrs [h, 2],
                               '" style="color:#111111">', hdrs [h, 1],
                               '</a></li>'))

    c (res, '</div>', '</nav>', '</div>', "")
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
        md [h] <- paste0 ('<section id="', nm, '" data-magellan-target="',
                          nm, '"><h', level, '>', hdr, '</h></section>')
    }
    return (md)
}

move_image_files <- function (md, fname, centre_images = TRUE,
                              rmd_fig_dir = "figure-gfm",
                              dest_dir = c ("assets", "img"))
{
    fp <- c (paste0 (fname, "_files"), rmd_fig_dir)
    path <- do.call (file.path, as.list (fp))
    flist <- list.files (path, full.names = TRUE)
    if (length (flist) > 0)
    {
        dest_dir <- c ("..", "..", dest_dir, fname)
        newpath <- do.call (file.path, as.list (dest_dir))
        if (!dir.exists (newpath))
            dir.create (newpath, recursive = TRUE)
        file.rename (flist, file.path (newpath, list.files (path)))
        unlink (paste0 (fname, "_files"), recursive = TRUE)

        # and change image location to newpath:
        md <- gsub (path, newpath, md)
        if (centre_images)
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
    }

    return (md)
}

blog_render ("blog01")