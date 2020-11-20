library(
    tidyverse
)

library(
    httr
)

library(
    jsonlite
)

library(
    lubridate
)

DNZapiComponents <- new.env(
)

DNZapiComponents$key <- Sys.getenv(
    "DIGITALNZAPIKEY"
)

DNZapiComponents$url1 <- paste(
    "https://api.digitalnz.org/v3/records.json?api_key=",
    DNZapiComponents$key,
    sep = ""
)

query_base <- "&and%5Bcollection%5D%5B%5D=Papers+Past&text=lithuania"

dnz_api_tibble <- function(
    query
) {
    retrieved <- fromJSON(
        query
    )
    results <- retrieved$search$results
    ID <- results$id
    Date <- dmy(
        results$display_date
    )
    Publisher <- unlist(
        results$publisher
    )
    result <- tibble(
        ID,
        Date,
        Publisher
    )
    return(
        result
    )
}

dnz_api_data <- function(
    base_query
) {
    query_count <- paste(
        base_query,
        "&per_page=1&page=1",
        sep = ""
    )
    retrieved <- GET(
        paste(
            DNZapiComponents$url1,
            query_count,
            sep = ""
        )
    ) %>% content(
    )
    record_count <- retrieved$search$result_count
    number_calls <- ceiling(
        record_count / 100
    )
    queries_data <- paste(
        DNZapiComponents$url1,
        base_query,
        "&per_page=100&page=",
        1:number_calls,
        sep = ""
    )
    retrieved <- tibble(
        ID = character(
        ),
        Date = character(
        ),
        Publisher = character(
        )
    )
    for (
        query in queries_data
    ) {
        Sys.sleep(
            0.1
        )
        retrieved <- rbind(
            retrieved,
            dnz_api_tibble(
                query
            )
        )
    }
    return(
        retrieved
    )
}

result <- dnz_api_data(
    query_base
)

result %>% ggplot(
    aes(
        x = Date,
        fill = Publisher
    )
) + geom_histogram(
    bins = 50L
) + scale_fill_hue(
) + theme_minimal(
)
