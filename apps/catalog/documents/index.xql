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


let $docs := collection('/db/lapidus/tei')/tei:TEI/tei:teiHeader

return
  <docs count = "{count($docs)}">
        { for $d in $docs 
          let $id   := $d/tei:fileDesc/tei:publicationStmt/tei:idno,
              $desc := $d/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr
          order by $desc/tei:title[@type='main']/@key
          return 
            <doc id = "{$id}">{ $desc }</doc>
        }
   </docs>
