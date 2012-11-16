import module namespace kwic="http://exist-db.org/xquery/kwic";
import module namespace ft="http://exist-db.org/xquery/lucene";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace request="http://exist-db.org/xquery/request";

declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare namespace html="http://www.w3.org/1999/xhtml";

declare namespace tei="http://www.tei-c.org/ns/1.0";

let $perpage := xs:integer(request:get-parameter("perpage", "10"))
let $start := xs:integer(request:get-parameter("start", "0"))
let $end := $start + $perpage

let $query := 
    if (request:get-parameter("about", ())) then
        <query>
            <term>{request:get-parameter("about",())}</term>
        </query>
     else null

let $hits :=
  if ($query) then
    collection('/db/lapidus/tei')//tei:teiHeader[ft:query(., $query)]
  else null

let $sorted-hits := 
  if ($query) then
    for $hit in $hits
    order by ft:score($hit) descending
    return $hit
  else null

let $results :=
  for $hit at $i in $sorted-hits[position() = ($start to $end)]
  let $collection :=  util:collection-name($hit)
  let $document   :=  util:document-name($hit)
  let $config     := <config xmlns="" width="60"/>
  let $summary    := kwic:summarize($hit, $config)
  let $count      := count($summary)
  let $oddeven    := if ($i mod 2) then "even" else "odd"
  return
    <div xmlns="http://www.w3.org/1999/xhtml" class="result {$oddeven}">

	<h3>{ concat($document, ' (', $count, ' matches)') }</h3>
	{
	  for $p at $i in $summary
	  let $class := if ($i mod 2) then "even" else "odd"
	  return
	  <p class="{$class}">
            {$p/(@*, *)}
	  </p>
	}
    </div>
    

return 
  <result uri="{request:get-uri()}" url="{substring-before(request:get-url(),'/documents')}" hitcount="{count($hits)}" query="{$query}">
    <context uri="{request:get-uri()}" url="{substring-before(request:get-url(),'/documents')}" hitcount="{count($hits)}" query="{$query}">
      <hitcount>{ count($hits) }</hitcount>
      <query>{ $query }</query>
    </context>
    <section xmlns="http://www.w3.org/1999/xhtml">
      { $results }
    </section>
  </result>
