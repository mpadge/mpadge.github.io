u <- "https://mpadge.r-universe.dev/api/packages/"
pkgs <- jsonlite::read_json (u, simplifyVector = TRUE)
cols <- c (
    "Package",
    "Title",
    "Description",
    "Version",
    "_downloads",
    "_devurl",
    "_pkgdown"
)
pkgs <- pkgs [, cols]
pkgs$on_cran <- !is.na (pkgs$`_downloads`$count) & pkgs$`_downloads`$count > 0L
index <- order (pkgs$`_downloads`$count, decreasing = TRUE)
pkgs <- pkgs [index, ]

u_base <- "https://raw.githubusercontent.com/ropensci-org/"
u <- paste0 (u_base, "badges/refs/heads/gh-pages/json/onboarded.json")
revs <- jsonlite::read_json (u, simplifyVector = TRUE)
revs <- revs [which (revs$pkgname %in% pkgs$Package), ]
pkgs$ros <- pkgs$Package %in% revs$pkgname
pkgs$roslink <- pkgs$rosstatus <- ""
index <- match (revs$pkgname, pkgs$Package)
pkgs$roslink [index] <-
    paste0 ("https://github.com/ropensci/software-review/", revs$iss_no)
pkgs$rosstatus [index] <-
    paste0 ("https://badges.ropensci.org/", revs$iss_no, "_status.svg")


out <- data.frame (
    link = pkgs$`_pkgdown`,
    package = pkgs$Package,
    cran = pkgs$on_cran,
    cranlink = ifelse (
        !pkgs$on_cran,
        "",
        paste0 ("https://cran.r-project.org/package=", pkgs$Package)
    ),
    cranlogs = ifelse (
        !pkgs$on_cran,
        "",
        pkgs$`_downloads`$source
    ),
    ros = ifelse (pkgs$ros, "yes", "no"),
    roslink = pkgs$roslink,
    rosstatus = pkgs$rosstatus,
    title = pkgs$Title,
    description = pkgs$Description
)
index <- which (nzchar (out$cranlogs))
out$cranlogs [index] <- paste0 (gsub (
    "downloads\\/total\\/last\\-month",
    "badges/grand-total",
    out$cranlogs [index]
), "?color=orange")

exclude <- c (
    "goodpractice",
    "libfuzzerr",
    "hotspotr"
)
out <- out [which (!out$title %in% exclude), ]

path <- "src/data/code.yml"
yaml::write_yaml (out, path, column.major = FALSE)
cli::cli_alert_success ("{path} updated")

# Then create "codeshort.yaml"
