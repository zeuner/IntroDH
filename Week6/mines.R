library(
    tidyverse
)

library(
    PBSmapping
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

ores <- (
    locs %>% distinct(
        tags,
        .keep_all = TRUE
    )
)

locs_geom <- geom_point(
    data = locs_raw,
    aes(
        x = reprLong,
        y = reprLat
    ),
    color = "grey70",
    alpha = .75,
    size = 1
)

file_name <- "Pleiades_mines.png"

header <- "mines"

p <- ggplot(
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

for (
    i in seq_along(
        ores$tags
    )
) {
    locs_ore <- filter(
        locs,
        grepl(
            ores$tags[
                i
            ],
            tags
        )
    )
    mined <- ores$tags[
        i
    ]
    p <- p + geom_point(
        data = locs_ore,
        aes(
            x = reprLong,
            y = reprLat,
            col = mined
        ),
        alpha = .75,
        size = 1
    )
} 

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

ggsave(
    file = file_name,
    plot = p,
    dpi = 600,
    width = 7,
    height = 6
)
