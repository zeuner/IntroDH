const fs = require(
    'fs'
)

try {
    const raw = fs.readFileSync(
        'starwars-episode-5-interactions.json',
        'utf8'
    )
    const data = JSON.parse(
        raw
    )
    console.log(
        "source,target,weight"
    )
    for (
        var i = 0;
        data.links.length > i;
        i++
    ) {
        var link = data.links[
            i
        ]
        console.log(
            '' + (
                link.source + 1
            ) + ',' + (
                link.target + 1
            ) + ',' + link.value
        )
    }
} catch (
    err
) {
    console.error(
        err
    )
}
