xquery version "3.0";

declare namespace mets="http://www.loc.gov/METS/";
declare namespace mods="http://www.loc.gov/mods/v3";

let $viafTable := fn:doc("file:///Users/cwulfman/Desktop/mask-viaf-by-constituent.xml")

let $files :=
for $row in $viafTable//row
    let $path := 'file://' || $row/urn_file
    let $available := fn:doc-available($path)
    where not($available)
    return 
        <file path="{$path}" available="{$available}"/>

return <fileSet>{ $files }</fileSet>