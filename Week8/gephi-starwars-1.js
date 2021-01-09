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
        "Source,Target"
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
            '"' + data.nodes[
                link.source
            ].name.split(
                '"'
            ).join(
                '""'
            ) + '","' + data.nodes[
                link.target
            ].name.split( 
                '"' 
            ).join( 
                '""' 
            ) + '"'
        )
    }
} catch (
    err
) {
    console.error(
        err
    )
}
