xquery version "1.0";

import module namespace request="http://exist-db.org/xquery/request";

declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare namespace html="http://www.w3.org/1999/xhtml";

declare namespace mods="http://www.loc.gov/mods/v3";


(:~
 :  Title-level record
 :  @return title-level MODS record for a periodical and all MODS records
 :  with that as its host.
:)

declare function local:dmd-urn($bmtnid as xs:string)
as xs:string
{
  concat("urn:PUL:bluemountain:dmd:", $bmtnid)
};

declare function local:urn($bmtnid as xs:string)
as xs:string
{
  concat("urn:PUL:bluemountain:", $bmtnid)
};

let $perpage := xs:integer(request:get-parameter("perpage", "50"))
let $start := xs:integer(request:get-parameter("start", "0"))
let $end := $start + $perpage

let $bmtnid := request:get-parameter("bmtnid","", true()) (:fail if no bmtnid provided:)

let $dmdURN := local:dmd-urn($bmtnid)

let $titleRec := 
  collection('/db/bluemtn')//mods:mods[mods:identifier[@type='bmtn'] = local:urn($bmtnid)]

let $constituents := 
  for $mods in collection('/db/bluemtn')//mods:mods
  let $host := $mods/mods:relatedItem[@type='host']/mods:recordInfo/mods:recordIdentifier
  where $host = $dmdURN
  order by $mods/mods:originInfo/mods:dateIssued[@keyDate='yes']
  return $mods

(:
let $results :=
  for $rec at $i in local:titleRecs()[position() = ($start to $end)]
  return $rec
:)
  return 
  <results>
    <titleRec>
      { $titleRec }
    </titleRec>
    <constituents count="{count($constituents)}">
      { $constituents }
    </constituents>
  </results>
