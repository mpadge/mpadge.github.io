parse_date <- function (date_str)
{
    as.Date (date_str, tryFormats = c (
        "%d/%m/%Y",
        "%d %b %Y",
        "%d %B %Y",
        "%Y-%m-%d",
        "%d %b %y"
    ))
}
