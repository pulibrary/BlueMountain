xquery version "3.0";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";

let $path := request:get-parameter("path", ())
let $tokens := tokenize($path, '/')
let $bmtnid := $tokens[2]
let $constituentid := request:get-parameter("constituentid", ())
let $data-root := request:get-parameter("data-root", ())

let $issueURN := string-join(('urn', 'PUL', 'bluemountain', $bmtnid), ':')
let $issueRec := collection($data-root)//mods:identifier[@type='bmtn' and . = $issueURN]/ancestor::mods:mods
let $constituentItem := $issueRec/mods:relatedItem[@ID = $constituentid]

return 
    <response>
        <headers>
            <path>{$path }</path>
            <bmtnid>{ $bmtnid }</bmtnid>
            <constituentid>{ $constituentid }</constituentid>
            <issueURN>{ $issueURN }</issueURN>
            <data-root>{$data-root}</data-root>
        </headers>
        <body>
            <metadata>{ $constituentItem }</metadata>
            <struct>
                {
                    $issueRec/ancestor::mets:mets/mets:structMap[@TYPE='LOGICAL']//mets:div[@DMDID = $constituentid]
                }
            </struct>
        </body>
    </response>
