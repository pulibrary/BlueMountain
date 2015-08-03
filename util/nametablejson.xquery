xquery version "3.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace json="http://www.json.org";
declare namespace mods="http://www.loc.gov/mods/v3";

declare option output:method "json";
declare option output:media-type "application/json";



let $recs := collection('/db/bluemtn/metadata/periodicals/bmtnaau/issues')//mods:mods
for $rec in $recs
    let $recid := xs:string($rec/mods:recordInfo/mods:recordIdentifier)
    for $name in $rec//mods:name
    let $viafid :=
    if ($name/ancestor::mods:name/@valueURI)
    then xs:string($name/ancestor::mods:name/@valueURI)
    else ()
    return
        <tr json:array="true">
            <name>{ xs:string($name/mods:displayForm) }</name>
            <viafid></viafid>
            <title>{ xs:string($name/parent::mods:relatedItem/mods:titleInfo[1]/mods:title[1]) }</title>
            <bmtnid>{ xs:string($name/parent::mods:relatedItem/@ID) }</bmtnid>
            <constid>{ $recid }</constid>
        </tr>
