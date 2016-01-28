xquery version "3.0";

declare namespace mets="http://www.loc.gov/METS/";
declare namespace mods="http://www.loc.gov/mods/v3";

let $viafTable := fn:doc("file:///Users/cwulfman/Desktop/mask-viaf-by-constituent.xml")


for $row in $viafTable//row
    let $path := 'file://' || $row/urn_file
    let $available := fn:doc-available($path)
    let $viafid := $row/CleanViaf
    let $constid := xs:string($row/constituent) 
    let $doc :=
        if ($available) then fn:doc($path) else ()
    let $constituent := 
        if ($viafid) then $doc//mods:relatedItem[@ID = $constid] else ()
    let $names :=
        if ($constituent) then $constituent//mods:name[mods:displayForm = $row/DisplayName]
        else ()
    where $names
    return
        for $name in $names
        let $authority := $name/@authority,
            $valueURI  := $name/@valueURI
        where (empty($valueURI))
        return
        (
        delete node $authority,
        delete node $name/@valueURI,
        insert node attribute authority { "viaf" } into $name,
        insert node attribute valueURI { $viafid } into $name
        
        )
