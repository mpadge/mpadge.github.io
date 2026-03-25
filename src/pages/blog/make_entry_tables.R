convert_markdown_tables_to_html <- function (md) {
    # Find table blocks: lines starting with |, with separator line containing dashes/colons
    table_start_indices <- integer()
    for (i in seq_along(md)) {
        if (grepl("^\\|", md[i])) {
            # Check if next line is separator (contains dashes and optionally colons for alignment)
            if (i < length(md) && grepl("^\\|[\\s:|-]+\\|", md[i + 1])) {
                table_start_indices <- c(table_start_indices, i)
            }
        }
    }

    if (length(table_start_indices) == 0) {
        return(md)
    }

    # Process each table
    for (start_idx in rev(table_start_indices)) {  # Process in reverse to maintain indices
        # Find end of table (next non-table line)
        end_idx <- start_idx + 1
        while (end_idx <= length(md) && grepl("^\\|", md[end_idx])) {
            end_idx <- end_idx + 1
        }
        end_idx <- end_idx - 1

        # Extract table lines
        table_lines <- md[start_idx:end_idx]

        # Convert markdown table to HTML
        html_table <- markdown_table_to_html(table_lines)

        # Replace in md vector
        if (start_idx <= end_idx) {
            md <- c(
                md[1:(start_idx - 1)],
                html_table,
                md[(end_idx + 1):length(md)]
            )
        }
    }

    return(md)
}

markdown_table_to_html <- function (table_lines) {
    # Parse markdown table and convert to HTML
    # table_lines should be: header, separator, data rows (all starting with |)

    # Split each line by |, trim whitespace, filter empty entries
    parse_row <- function (line) {
        parts <- strsplit(line, "|", fixed = TRUE)[[1]]
        # Remove first element (empty string from leading |)
        if (length(parts) > 0) {
            parts <- parts[-1]
        }
        # Remove last element if it's empty (from trailing |)
        if (length(parts) > 0 && trimws(parts[length(parts)]) == "") {
            parts <- parts[-length(parts)]
        }
        trimws(parts)
    }

    header <- parse_row(table_lines[1])
    separator <- parse_row(table_lines[2])

    # Determine alignment from separator (---, :--:, :---, ---:)
    get_alignment <- function (sep_cell) {
        sep_cell <- trimws(sep_cell)
        if (grepl("^:-+:$", sep_cell)) {
            "center"
        } else if (grepl("^:-+", sep_cell)) {
            "left"
        } else if (grepl("-+:$", sep_cell)) {
            "right"
        } else {
            "left"  # default
        }
    }

    alignments <- sapply(separator, get_alignment)

    # Start building HTML
    html <- c("<table>", "<thead>", "<tr>")
    for (i in seq_along(header)) {
        style <- paste0('style="text-align: ', alignments[i], ';"')
        html <- c(html, paste0('<th ', style, '>', header[i], '</th>'))
    }
    html <- c(html, "</tr>", "</thead>", "<tbody>")

    # Data rows
    for (row_idx in 3:length(table_lines)) {
        data <- parse_row(table_lines[row_idx])
        html <- c(html, "<tr>")
        for (i in seq_along(data)) {
            style <- paste0('style="text-align: ', alignments[i], ';"')
            html <- c(html, paste0('<td ', style, '>', data[i], '</td>'))
        }
        html <- c(html, "</tr>")
    }

    html <- c(html, "</tbody>", "</table>")
    return(html)
}
