xquery version "3.0";


declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace json="http://www.json.org";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";


(: Switch to JSON serialization
declare option output:method "json";
declare option output:media-type "text/javascript";
 :)
declare option output:method "text";
declare option output:media-type "text/javascript";


declare function local:issues($data-root, $titleURN)
{
    let $issues := 
        collection($data-root)//mods:relatedItem[@type='host' and @xlink:href= $titleURN]/ancestor::mets:mets
        
    for $issue in $issues
            let $date := $issue/mets:dmdSec//mods:originInfo/mods:dateIssued[@keyDate='yes']
            let $pagecount := count($issue/mets:structMap[@TYPE='PHYSICAL']/mets:div[@TYPE='Magazine']/mets:div)
            order by $date
            return
                <issue>
                    <date>{ xs:string($date) }</date>
                    <pagecount>{ $pagecount }</pagecount>
                </issue>
};

let $xsl := doc("../resources/xsl/toJSON.xsl")

let $bmtnid := request:get-parameter("bmtnid", ())
let $data-root := request:get-parameter("data-root", ())
let $titleURN := string-join(('urn', 'PUL', 'bluemountain', $bmtnid), ':')
let $titleRec := collection($data-root)//mods:identifier[@type='bmtn' and . = $titleURN]/ancestor::mods:mods
let $issues-old := collection($data-root)//mods:relatedItem[@type='host' and @xlink:href= $titleURN]/ancestor::mets:mets
let $issues := local:issues($data-root, $titleURN)
let $old := <response>
        <headers>
            <bmtnid>{$bmtnid}</bmtnid>
            <titleURN>{ $titleURN }</titleURN>
            <data-root>{$data-root}</data-root>
            <issuecount>{ count($issues) }</issuecount>
        </headers>
        <issues>{
            for $issue in $issues
            let $date := $issue/mets:dmdSec//mods:originInfo/mods:dateIssued[@keyDate='yes']
            let $pagecount := count($issue/mets:structMap[@TYPE='PHYSICAL']/mets:div[@TYPE='Magazine']/mets:div)
            order by $date
            return
                <issue>
                    <date>{ xs:string($date) }</date>
                    <pagecount>{ $pagecount }</pagecount>
                </issue>
        }</issues>
    </response>

return
 transform:transform($issues, $xsl, ()) 
