# Convert .Rmd to HTML for RSS feeds

extract_rmd_content <- function (rmd_file) {
    con <- file (rmd_file)
    x <- readLines (con)
    close (con)

    # Extract content after frontmatter (skip the closing ---)
    index <- which (x == "---")
    if (length (index) < 2) {
        return ("")
    }
    content <- x [(index [2] + 1):length (x)]

    # Remove leading/trailing empty lines
    content <- content [!grepl ("^\\s*$", content)]
    if (length (content) == 0) {
        return ("")
    }

    content
}

convert_md_to_html <- function (md_lines) {
    tmp_md <- tempfile (fileext = ".md")
    writeLines (md_lines, tmp_md)

    tmp_html <- tempfile (fileext = ".html")
    rmarkdown::render (
        tmp_md,
        output_format = rmarkdown::html_fragment(),
        output_file = tmp_html,
        quiet = TRUE
    )
    html_lines <- readLines (tmp_html)
    unlink (tmp_md)
    unlink (tmp_html)

    html_str <- paste0 (html_lines, collapse = "\n")
    # Escape special YAML characters:
    html_str <- gsub ("'", "''", html_str, fixed = TRUE)

    html_str
}

get_blog_content <- function (rmd_file) {
    md_content <- extract_rmd_content (rmd_file)
    if (length (md_content) == 0 || all (md_content == ""))
        return ("")

    html_content <- convert_md_to_html (md_content)
    html_content
}

generate_all_blog_content <- function () {
    # Get all .Rmd blog files in current directory
    rmd_files <- list.files (".", pattern = "*.Rmd$")

    # Extract and convert content for all files
    content_list <- lapply (rmd_files, function (f) {
        get_blog_content (f)
    })

    # Return as named list (filename -> content)
    names (content_list) <- rmd_files
    content_list
}

generate_rss_feed <- function (blog_data, all_content, output_file = "feed.xml")
{
    # Sort blog_data by creation date (most recent first)
    blog_data <- blog_data [order (as.Date (blog_data$created, format = "%d %b %y"),
                                    decreasing = TRUE), ]

    # Build RSS feed
    feed <- '<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/">
  <channel>
    <title>mpadge blog</title>
    <link>https://mpadge.github.io/blog</link>
    <description>R, C++, spatial, open data</description>
    <atom:link href="https://mpadge.github.io/feed.xml" rel="self" type="application/rss+xml"/>'

    # Add items for each blog post
    for (i in seq_len (nrow (blog_data)))
    {
        b <- blog_data [i, ]
        rmd_file <- paste0 (sub (".html$", "", b$link), ".Rmd")
        content <- all_content [[rmd_file]]
        if (is.null (content))
            content <- ""

        feed <- paste0 (feed, '\n    <item>
      <title>', b$title, '</title>
      <link>https://mpadge.github.io/blog/', b$link, '</link>
      <guid>https://mpadge.github.io/blog/', b$link, '</guid>
      <description>', b$description, '</description>
      <content:encoded><![CDATA[', content, ']]></content:encoded>
      <pubDate>', b$created, '</pubDate>
    </item>')
    }

    feed <- paste0 (feed, '\n  </channel>
</rss>')

    writeLines (feed, output_file)
}
