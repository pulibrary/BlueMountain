xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace tei="http://www.tei-c.org/ns/1.0";


let $doc := collection('/db/lapidus')/tei:TEI[.//tei:publicationStmt/tei:idno = request:get-parameter("id", ())]

return
  if (request:get-parameter("page", ()))
    then
    let $i := xs:integer(request:get-parameter("page",()))
    let $pbs := $doc//tei:pb
    let $p1 := $pbs[$i]
    let $p2 := $pbs[$i + 1]
    let $p := $doc//tei:pb[xs:integer(request:get-parameter("page",()))]
    let $surface := $doc/id($p1/@facs)
    return
      <page thumb="{$surface/tei:graphic[@ana='thumbnail']/@url}">
      { $p1/following-sibling::text() intersect $p2/preceding-sibling::text() }
      </page>


  else  <doc>{ $doc }</doc>
      