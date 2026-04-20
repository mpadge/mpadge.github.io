read_md_content <- function (md_file)
{
    x <- readLines (md_file)
    x <- x [!grepl ("^\\s*$", x)]  # drop blank lines
    if (length (x) == 0) return ("")
    x
}

convert_md_to_html <- function (md_lines)
{
    tmp_md   <- tempfile (fileext = ".md")
    tmp_html <- tempfile (fileext = ".html")
    writeLines (md_lines, tmp_md)

    rmarkdown::render (
        tmp_md,
        output_format = rmarkdown::html_fragment (),
        output_file   = tmp_html,
        quiet         = TRUE
    )

    html_str <- paste0 (readLines (tmp_html), collapse = "\n")
    unlink (c (tmp_md, tmp_html))

    # Escape single quotes for YAML safety
    gsub ("'", "''", html_str, fixed = TRUE)
}

get_blog_content <- function (md_file)
{
    md <- read_md_content (md_file)
    if (all (md == "")) return ("")
    convert_md_to_html (md)
}

generate_rss_feed <- function (blog_data, output_file = "feed.xml")
{
    blog_data <- blog_data [order (
        as.Date (blog_data$created, format = "%d %b %y"),
        decreasing = TRUE
    ), ]

    feed <- '<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/">
  <channel>
    <title>mpadge blog</title>
    <link>https://mpadge.eu/blog</link>
    <description>R, C++, spatial, open data</description>
    <atom:link href="https://mpadge.eu/feed.xml" rel="self" type="application/rss+xml"/>'

    for (i in seq_len (nrow (blog_data)))
    {
        b       <- blog_data [i, ]
        md_file <- paste0 (sub ("\\.html$", "", b$link), ".md")
        content <- if (file.exists (md_file)) get_blog_content (md_file) else ""

        feed <- paste0 (feed, '\n    <item>
      <title>', b$title, '</title>
      <link>https://mpadge.eu/blog/', b$link, '</link>
      <guid>https://mpadge.eu/blog/', b$link, '</guid>
      <description>', b$description, '</description>
      <content:encoded><![CDATA[', content, ']]></content:encoded>
      <pubDate>', b$created, '</pubDate>
    </item>')
    }

    feed <- paste0 (feed, '\n  </channel>\n</rss>')
    writeLines (feed, output_file)
}
