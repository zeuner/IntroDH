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
        "id,label,scene_occ"
    )
    for (
        var i = 0;
        data.nodes.length > i;
        i++
    ) {
        var node = data.nodes[
            i
        ]
        console.log(
            '' + (
                i + 1
            ) + ',"' + node.name.split( 
                '"' 
            ).join( 
                '""' 
            ) + '",' + node.value
        )
    }
} catch (
    err
) {
    console.error(
        err
    )
}
