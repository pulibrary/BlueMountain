import module namespace kwic="http://exist-db.org/xquery/kwic";
import module namespace ft="http://exist-db.org/xquery/lucene";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace request="http://exist-db.org/xquery/request";

declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare namespace html="http://www.w3.org/1999/xhtml";

declare namespace mods="http://www.loc.gov/mods/v3";


(:~
 :  Title-level records
 :  @return sequence of MODS records.
 :  Algorithm: any MODS record without a relatedItem[@type='host'] 
 :  is a title-level record.  This is, perhaps, a weak assumption,
 :  but there is no explicit declaration of MODS type at this
 :  point.
:)

declare function local:titleRecs()
as element()+
{
  for $rec in collection('/db/bluemtn')//mods:mods
  where empty($rec/mods:relatedItem[@type='host'])
  return $rec
};


let $perpage := xs:integer(request:get-parameter("perpage", "50"))
let $start := xs:integer(request:get-parameter("start", "0"))
let $end := $start + $perpage

let $results :=
  for $rec at $i in local:titleRecs()[position() = ($start to $end)]
  return $rec

return 
  <results count="{count($results)}">
  { $results }
  </results>
