xquery version "3.0";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";
declare option output:media-type "text/plain";


let $header := concat(string-join(('title', 'constituentid', 'issueid', 'byline'), '&#9;'), '&#10;')
let $collection := '/db/bluemtn/metadata/periodicals/bmtnaau/issues'
let $bylines := collection($collection)//mods:relatedItem[@type='constituent']//mods:displayForm
let $body :=
    for $byline in $bylines
    let $title := xs:string($byline/ancestor::mods:relatedItem[1]/mods:titleInfo[1]/mods:title)
    let $constituentid := xs:string($byline/ancestor::mods:relatedItem[1]/@ID)
    let $issueid := xs:string($byline/ancestor::mods:mods[1]/mods:identifier[@type='bmtn'])
    return
        concat(string-join(($issueid, $constituentid, $title, xs:string($byline)), '&#9;'), '&#10;')
return
     
    ($header, $body)
    
        
    