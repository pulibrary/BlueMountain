xquery version "3.0";

(:
  This update query seems to eat a lot of memory. Increasing Oxygen's java memory (-Xmx1500m) helps; 
  you may still find that it appears to fail with "duplicate attributes" error.  Running the query
  several times seems to do the trick.
:)

declare namespace mets="http://www.loc.gov/METS/";
declare namespace mods="http://www.loc.gov/mods/v3";

let $viafTable := fn:doc("file:///Users/cwulfman/Desktop/mask-viaf-by-constituent.xml")


for $row in $viafTable//row
    let $path := 'file://' || $row/urn_file
    let $available := fn:doc-available($path)
    let $viafid := $row/CleanViaf/text()
    let $constid := xs:string($row/constituent) 
    let $doc :=
        if ($available) then fn:doc($path) else ()
    let $constituent := 
        if ($viafid) then $doc//mods:relatedItem[@ID = $constid] else ()
    let $names :=
        if ($constituent) then $constituent/mods:name[mods:displayForm = $row/DisplayName]
        else ()
    where $viafid
    return
        for $name in $names
        let $authority := $name/@authority,
            $valueURI  := $name/@valueURI
        where ($viafid and empty($name/@valueURI))
        return
            insert node attribute valueURI { $viafid } into $name
