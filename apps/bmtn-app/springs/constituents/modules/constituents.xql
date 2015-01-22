xquery version "3.0";

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


let $bmtnid := request:get-parameter("issueid", ())
let $constituentid := request:get-parameter("constituentid", ())
let $data-root := request:get-parameter("data-root", ())

let $issueURN := string-join(('urn', 'PUL', 'bluemountain', $bmtnid), ':')
let $issueRec := collection($data-root)//mods:identifier[@type='bmtn' and . = $issueURN]/ancestor::mods:mods
let $constituentItem := $issueRec/mods:relatedItem[@ID = $constituentid]

let $mets := $issueRec/ancestor::mets:mets
let $logicalDiv := 
    if ($constituentid) then
      $issueRec/ancestor::mets:mets/mets:structMap[@TYPE='LOGICAL']//mets:div[@DMDID = $constituentid]
    else 
       $issueRec/ancestor::mets:mets/mets:structMap[@TYPE='LOGICAL']/mets:div[1]
    let $plaintext :=
            for $area in $logicalDiv//mets:area
            let $adoc := local:altodoc($mets, $area/@FILEID) 
            let $uri := concat($adoc, '#', $area/@BEGIN/string())
            return local:alto2txt(doc($adoc)//node()[@ID = $area/@BEGIN])

return 
(:    <response>
        <headers>

            <bmtnid>{ $bmtnid }</bmtnid>
            <constituentid>{ $constituentid }</constituentid>
            <issueURN>{ $issueURN }</issueURN>
            <data-root>{ $data-root }</data-root>
        </headers>
        <body>
            <metadata>{ $constituentItem }</metadata>
            <struct>{ $logicalDiv }</struct>
            <text>{ $plaintext }</text>
        </body>
    </response>:)


<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>{$constituentid}</title>
    </head>
    <body>
    <nav>
        <ol>
            <li><a href="../">Blue Mountain Springs</a></li>
            <li><a href="{$bmtnid}">the issue</a></li>
        </ol>
    </nav>
        <header>
            <h1>{$constituentItem/mods:titleInfo}</h1>
            <p>{$issueRec/mods:titleInfo[1]/mods:title[1]}</p>
            <p>{$logicalDiv/@LABEL/string()}</p>
        </header>
        <section>
            <h1>Logical Div</h1>
            { $logicalDiv }
        </section>
        <section>
        <h1>Alto Elements</h1>

        <ol>
        {
            for $area in $logicalDiv//mets:area
            let $adoc := local:altodoc($mets, $area/@FILEID) 
            let $uri := concat($adoc, '#', $area/@BEGIN/string())
            return <li><a href="http://localhost:8080/exist/rest{$uri}">{$uri}</a></li>
        }
        </ol>
    </section>
    <section id="txt">
    <h1>Plain Text</h1>
    <div class="content">
    {
            for $area in $logicalDiv//mets:area
            let $adoc := local:altodoc($mets, $area/@FILEID) 
            let $uri := concat($adoc, '#', $area/@BEGIN/string())
            return 
                        local:alto2txt(doc($adoc)//node()[@ID = $area/@BEGIN])

        }
    </div>
    </section>
    <section>
        <h1>Page Images</h1>
        {
            let $imagefiles :=
                for $area in $logicalDiv//mets:area
                let $altogroup := $mets//mets:file[@ID = $area/@FILEID]/@GROUPID
                return $mets//mets:fileGrp[@USE='Images']/mets:file[@GROUPID = $altogroup]
            return
                <ol>
                {
                    for $f in $imagefiles intersect $imagefiles
                    return
                        <li>{$f/mets:FLocat/@xlink:href/string()}</li>
                }
                </ol>
        }
 
    </section>
    </body>
</html>