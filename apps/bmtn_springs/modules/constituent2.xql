xquery version "3.0";

import module namespace config="http://bluemountain.princeton.edu/springs/config" at "config.xqm";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace alto="http://www.loc.gov/standards/alto/ns-v2#";


declare function local:altodoc($metsdoc as node(), $id as node()) 
as xs:string {
    let $metsuri := document-uri(root($metsdoc) )
    let $tokens := tokenize($metsuri, '/')
    let $base := subsequence($tokens, 1, count($tokens) - 1)
    let $altohref := substring-after($metsdoc//mets:file[@ID = $id]/mets:FLocat/@xlink:href/string(), 'file://./alto/')
    let $foo := insert-before($base, count($base) + 1, ("alto", $altohref))
    return string-join($foo, '/')
};


declare function local:alto2txt($textblock) {
    for $string in $textblock//alto:String
    return $string/@CONTENT/string()
};

let $bmtnid := request:get-parameter("bmtnid", ())
let $constituentid := request:get-parameter("constituentid", ())
let $mode := request:get-parameter("mode", ())
let $issueURN := concat('urn:PUL:bluemountain:', $bmtnid)
let $issueRec := collection('/db/bluemtn')//mods:mods[mods:identifier[@type='bmtn'] = $issueURN]
let $constituent := $issueRec/mods:relatedItem[@ID = $constituentid]
let $mets := $issueRec/ancestor::mets:mets
let $logicalDiv := $issueRec/ancestor::mets:mets/mets:structMap[@TYPE='LOGICAL']//mets:div[@DMDID = $constituentid]

let $plaintext :=
            for $area in $logicalDiv//mets:area
            let $adoc := local:altodoc($mets, $area/@FILEID) 
            let $uri := concat($adoc, '#', $area/@BEGIN/string())
            return local:alto2txt(doc($adoc)//node()[@ID = $area/@BEGIN])
return

<result bmtnid="{$bmtnid}">
    <text>
        { $plaintext }
    </text>
</result>
