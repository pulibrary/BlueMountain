xquery version "3.0";

declare namespace mods="http://www.loc.gov/mods/v3";

let $bmtnid := request:get-parameter("bmtnid", ())
let $data-root := request:get-parameter("data-root", ())
let $titleURN := string-join(('urn', 'PUL', 'bluemountain', $bmtnid), ':')
let $titleRec := collection($data-root)//mods:identifier[@type='bmtn' and . = $titleURN]/ancestor::mods:mods

return 
    <response>
        <headers>
            <bmtnid>{$bmtnid}</bmtnid>
            <titleURN>{ $titleURN }</titleURN>
            <data-root>{$data-root}</data-root>
        </headers>
        <body>
        { $titleRec }
        </body>
    </response>
