library(
    tidyverse
)

library(
    PBSmapping
)

library(
    gganimate
)

xlim <- c(
    -12,
    55
)

ylim <- c(
    20,
    60
)

landborder <- "lightgrey"

land <- "lightgrey"

worldmap <- map_data(
    "world"
)

colnames(
    worldmap
) <- c(
    "X",
    "Y",
    "PID",
    "POS",
    "region",
    "subregion"
)

worldmap <- clipPolys(
    worldmap,
    xlim = xlim,
    ylim = ylim,
    keepExtra = TRUE
)

locs_raw <- read_csv(
    "http://atlantides.org/downloads/pleiades/dumps/pleiades-places-latest.csv.gz"
)

dataLabel <- "Data: Pleiades Project"

locs <- filter(
    locs_raw,
    grepl(
        'mine',
        featureTypes
    )
)

locs <- (
    locs %>% mutate(
        tags = strsplit(
            as.character(
                tags
            ),
            ", "
        )
    ) %>% unnest(
        tags
    )
)

locs <- filter(
    locs,
    !grepl(
        'dare:major=',
        tags
    ),
    !grepl(
        'dare:ancient=',
        tags
    ),
    !grepl(
        'dare:feature=',
        tags
    ),
    grepl(
        '[a-z]',
        tags
    )
)

preprocess_periods <- function(
    locs_base
) {
    locs_processed <- (
        locs_base %>% mutate(
            timePeriodsKeys = strsplit(
                as.character(
                    timePeriodsKeys
                ),
                ","
            )
        ) %>% unnest(
            timePeriodsKeys
        )
    )
    locs_processed <- filter(
        locs_processed,
        grepl(
            '^(archaic|classical|hellenistic-republican|roman|late-antique)$',
            timePeriodsKeys
        )
    )
    locs_processed$timePeriodsKeys <- factor(
        locs_processed$timePeriodsKeys,
        levels = c(
            "archaic",
            "classical",
            "hellenistic-republican",
            "roman",
            "late-antique"
        )
    )
    return(
        locs_processed
    )
}

locs <- preprocess_periods(
    locs
)

locs_indif <- preprocess_periods(
    locs_raw
)

locs_geom <- geom_point(
    data = locs_indif,
    aes(
        x = reprLong,
        y = reprLat
    ),
    color = "grey70",
    alpha = .75,
    size = 1
)

file_name <- "Pleiades_mines.gif"

header <- "Mines in the {closest_state} period"

p <- ggplot(
)

p <- p + transition_states(
    timePeriodsKeys
)

p <- p + coord_map(
    xlim = xlim,
    ylim = ylim
)

p <- p + geom_polygon(
    data = worldmap,
    mapping = aes(
        X,
        Y,
        group = PID
    ),
    size = 0.1,
    colour = landborder,
    fill = land,
    alpha = 1
)

p <- p + locs_geom

p <- p + geom_point(
    data = locs,
    aes(
        x = reprLong,
        y = reprLat,
        col = tags
    ),
    alpha = .75,
    size = 1
)

p <- p + labs(
    title = header,
    y = "",
    x = ""
)

p <- p + annotate(
    "text",
    x = -11,
    y = 21,
    hjust = 0,
    label = dataLabel,
    size = 3,
    color = "grey40"
)

p <- p + theme_minimal(
    base_family = "serif"
)

p <- p + theme(
    panel.background = element_rect(
        fill = "darkslategrey"
    )
)

p <- p + enter_grow(
)

p <- p + exit_shrink(
)

p <- p + ease_aes(
    'cubic-in-out'
)

animation <- animate(
    p
)

anim_save(
    file_name,
    animation = animation
)
