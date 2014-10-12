xquery version "3.0";

module namespace app="http://blaueberg.info/bmtneer/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://blaueberg.info/bmtneer/config" at "config.xqm";
import module namespace bmtneer="http://blaueberg.info/bmtneer" at "bmtneer-module.xqm";
import module namespace kwic = "http://exist-db.org/xquery/kwic"
    at "resource:org/exist/xquery/lib/kwic.xql";


declare namespace mets="http://www.loc.gov/METS/";
declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace alto="http://www.loc.gov/standards/alto/ns-v2#";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(: 
 TITLE TEMPLATES
 :)


declare function app:title-count($node as node(), $model as map(*)) 
as xs:integer 
{ count($model("titles")) };

declare function app:selected-title-issue-count($node as node(), $model as map(*)) 
as xs:integer 
{ count($model("selected-title-issues")) };

declare %templates:wrap function app:selected-titles($node as node(), $model as map(*)) 
as map(*) 
{
    let $titleSequence :=
        for $rec in collection('/db/bluemtn/metadata/periodicals')//mods:genre[.='Periodicals-Title']/ancestor::mods:mods
        order by upper-case($rec/mods:titleInfo[empty(@type)]/mods:title/string())
        return $rec
    return map { "titles" := $titleSequence }
};

declare %templates:wrap function app:selected-title($node as node(), $model as map(*), $titleURN as xs:string?)
as map(*)? 
{
    if ($titleURN) then
        let $titleRec := collection('/db/bluemtn/metadata/periodicals')//mods:identifier[@type='bmtn' and . = $titleURN]/ancestor::mods:mods
        return map { "selected-title" := $titleRec }    
     else ()
};

declare function app:selected-title-issues($node as node(), $model as map(*))
as map(*)
{
    let $titleURN := $model("selected-title")/mods:identifier[@type='bmtn']
    let $issues := 
        for $issue in
            collection('/db/bluemtn/metadata/periodicals')//mods:mods[mods:relatedItem[@type='host']/@xlink:href = $titleURN]
        let $date := $issue/mods:originInfo/mods:dateIssued[@keyDate='yes']
        order by xs:dateTime(app:w3cdtf-to-xsdate($date))
        return $issue
    return map { "selected-title-issues" := $issues }
};

declare function app:selected-title-listing($node as node(), $model as map(*))
as element()*
{
       let $titles := $model("titles")
  let $w-size := 3
let $row-count := xs:int(ceiling(count($titles) div $w-size) )
        let $xsl := doc("/db/apps/bmtneer/resources/xsl/entry.xsl")
        let $xslt-parameters := 
            <parameters>
                <param name="context" value="title-listing"/>
            </parameters>
return
<div class="row">
{ 
for $title in $titles
return
transform:transform($title, $xsl, $xslt-parameters)
}
</div>
};

declare function app:selected-title-listing-old($node as node(), $model as map(*))
as element()
{
    <ol class='title-listing'>{
        for $title in $model("titles")
        let $titleURN := $title/mods:identifier[@type='bmtn']
        let $titleInfo := $title/mods:titleInfo[empty(@type)]
        let $tstring :=
            if ($titleInfo/mods:nonSort)
            then concat($titleInfo/mods:nonSort/string(), " ")
            else ""
         let $tstring := $tstring || $titleInfo/mods:title/string()
         return
           <li>
            <a href="title.html?titleURN={$titleURN}">{$tstring}</a>
           </li>
    }</ol>
};

declare
  %templates:wrap
function app:selected-title-pub-dates($node as node(), $model as map(*))
as element()*
{
  let $title := $model("selected-title")  
  return $title/mods:originInfo/mods:dateIssued[empty(@point)]
};

declare 
%templates:wrap
function app:selected-title-label($node as node(), $model as map(*))
as element()*
{
    let $selected-title := $model("selected-title")
    let $xsl := doc("/db/apps/bmtneer/resources/xsl/entry.xsl")
    let $xslt-parameters := 
        <parameters>
            <param name="context" value="selected-title-label"/>
        </parameters>
    return transform:transform($selected-title, $xsl, $xslt-parameters)
};


declare function app:title-label($node as node(), $model as map(*)) {
    let $titleInfo := $model("title")/mods:titleInfo[empty(@type)]
    let $tstring :=
        if ($titleInfo/mods:nonSort)
        then concat($titleInfo/mods:nonSort/string(), " ")
        else ""
    let $tstring := $tstring || $titleInfo/mods:title/string()
    return <a href="catalog.html?bmtnid={$model("title")/mods:identifier[@type='bmtn']}">{$tstring}</a>
};

declare
%templates:wrap
function app:selected-title-icon($node as node(), $model as map(*))
as element()*
{
    let $selected-title := $model("selected-title")
    let $bmtnid := fn:tokenize($selected-title/mods:identifier[@type='bmtn'], ':')[last()]
    let $path-to-icon := "http://localhost:8080/exist/rest/db/bluemtn/resources/icons/periodicals"
    
    return 
        <img src="{string-join(($path-to-icon, $bmtnid, 'large.jpg'), '/')}"
             alt="icon" />
    
};

declare function app:selected-title-issue-listing-group($node as node(), $model as map(*))
as element()*
{
  for $issueByVolume in $model("selected-title-issues")  
  group by $volnum := $issueByVolume/mods:part[@type='issue']/mods:detail[@type='volume']/mods:number[1]
  order by $volnum
  return
        <ul>
            <li>
                <h3>Volume { $volnum/text() }</h3>
                <ul>
                {
                    for $issue in $issueByVolume
                    group by $issuenum := $issue/mods:part[@type='issue']/mods:detail[@type='number']/mods:number[1]
                    order by $issuenum
                    return
                        <li>Number { $issuenum }</li>
                }    
                </ul>
            </li>  
        </ul>
};

declare function app:selected-title-issue-listing($node as node(), $model as map(*))
as element()
{
    <table class="table">
        <tr><th>Volume</th><th>Number</th><th>Date Issued</th><th>Access</th></tr>
        {
    for $issueByVolume in $model("selected-title-issues")
            let $issueURN := $issueByVolume/mods:identifier[@type='bmtn']/string()
        let $titleURN := $issueByVolume/mods:relatedItem[@type='host']/@xlink:href

    let $vollabel := 
            if ($issueByVolume/mods:part[@type='issue']/mods:detail[@type='volume']/mods:caption) then
                $issueByVolume/mods:part[@type='issue']/mods:detail[@type='volume']/mods:caption
             else   
                $issueByVolume/mods:part[@type='issue']/mods:detail[@type='volume']/mods:number[1]
    let $issuelabel := 
            if ($issueByVolume/mods:part[@type='issue']/mods:detail[@type='number']/mods:caption) then
                $issueByVolume/mods:part[@type='issue']/mods:detail[@type='number']/mods:caption
            else
                $issueByVolume/mods:part[@type='issue']/mods:detail[@type='number']/mods:number[1]
                
     let $volnum   := $issueByVolume/mods:part[@type='issue']/mods:detail[@type='volume']/mods:number[1]
     let $issuenum := $issueByVolume/mods:part[@type='issue']/mods:detail[@type='number']/mods:number[1]
     
    let $date := $issueByVolume/mods:originInfo/mods:dateIssued[@keyDate='yes']
    order by xs:integer($volnum[1]),xs:integer($issuenum)
    return
        <tr>
            <td>{string($vollabel)}</td>
            <td>{string($issuelabel)}</td>
            <td>{$date/text()}</td>
            <td><a href="issue.html?titleURN={$titleURN}&amp;issueURN={ $issueURN }">detail</a></td>
        </tr>
    }</table>
};



(: 
 : ISSUE TEMPLATES
 :)
 
 declare %templates:wrap function app:issue-icon($node as node(), $model as map(*))
 as element()
 {
    let $issueURN := $model("selected-issue")//mods:identifier
    let $iconpath := bmtneer:icon-path($issueURN)
    return <img src="{$iconpath}/large.jpg" />
 };

declare %templates:wrap function app:selected-issue($node as node(), $model as map(*), $issueURN as xs:string?)
as map(*)? 
{
    if ($issueURN) then
        let $issueRec := collection('/db/bluemtn/metadata/periodicals')//mods:identifier[@type='bmtn' and . = $issueURN]/ancestor::mets:mets
        return map { "selected-issue" := $issueRec }    
     else ()
};

declare function app:selected-issue-constituents($node as node(), $model as map(*))
as map(*)
{
    map { "selected-issue-constituents" := $model("selected-issue")//mods:relatedItem[@type='constituent'] }    
};




(: 
 : Constituent Templates
 :)

declare %templates:wrap function app:selected-constituent($node as node(), $model as map(*), $titleURN as xs:string?, $issueURN as xs:string?, $constituentID as xs:string?)
as map(*)? 
{
    if ($issueURN and $constituentID) then
        let $issueRec := collection('/db/bluemtn/metadata/periodicals')//mods:identifier[@type='bmtn' and . = $issueURN]/ancestor::mods:mods
        let $titleReca := collection('/db/bluemtn/metadata/periodicals')//mods:identifier[@type='bmtn' and .= $titleURN]/ancestor::mods:mods
        let $titleRec := collection('/db/bluemtn/metadata/periodicals')//mods:identifier[@type='bmtn' and .= $issueRec//mods:relatedItem[@type='host']/@xlink:href]/ancestor::mods:mods
        let $constituent-r-item := $issueRec/mods:relatedItem[@ID = $constituentID]
        let $mets := $issueRec/ancestor::mets:mets
        let $logicalDiv := $issueRec/ancestor::mets:mets/mets:structMap[@TYPE='LOGICAL']//mets:div[@DMDID = $constituentID]
        let $plaintext :=
            for $area in $logicalDiv//mets:area
            let $adoc := local:altodoc($mets, $area/@FILEID)
            return local:alto2txt(doc($adoc)//node()[@ID = $area/@BEGIN])
        return map { "selected-constituent-text" := $plaintext, 
                     "selected-constituent" := $constituent-r-item, 
                     "selected-title" := $titleRec,
                     "selected-issue" := $issueRec/ancestor::mets:mets,
                     "selected-constituent-logical-div" := $logicalDiv                     
                     }
     else ()
};

declare function app:selected-constituent-contents($node as node(), $model as map(*))
{
  $model("selected-constituent-text")  
};

declare function app:selected-constituent-contents-html($node as node(), $model as map(*))
{
   (: $model("selected-constituent-logical-div") :)
   
    (: $model("selected-issue") :)
    local:parse-structMap-div($model("selected-constituent-logical-div")) 
   
};

declare function local:parse-structMap-div($div as element()?)
{
    if (empty($div)) then <h1>empty structmap!</h1>
    else 
    <div class="{$div/@TYPE}">
        {
          for $div in $div/mets:div
          return local:parse-structMap-div($div)
        }
        {
            for $fptr in $div/mets:fptr
            return local:parse-fptr($fptr)
        }
    </div>    
    };
    
declare function local:parse-fptr-old($fptr as node())
{
    let $metsdoc := $fptr/ancestor::mets:mets
    let $altoID  := $fptr/mets:area/@FILEID
    let $altodoc := local:altodoc($metsdoc, $altoID)
    return local:alto2html(doc($altodoc)//node()[@ID = $fptr/mets:area/@BEGIN])
};

declare function local:parse-fptr($fptr as node())
{
    let $metsdoc := $fptr/ancestor::mets:mets
    let $html    :=
        for $area in $fptr//mets:area
        let $altoID  := $area/@FILEID
        let $altodoc := local:altodoc($metsdoc, $altoID)
        return local:alto2html(doc($altodoc)//node()[@ID = $area/@BEGIN])

    return $html
};

declare function app:selected-issue-constituents-listing($node as node(), $model as map(*))
as element()
{
    <ol class="constituent-listing">{
        
        let $issueURN := $model("selected-issue")//mods:identifier[@type='bmtn']
        let $titleURN := $model("selected-issue")//mods:relatedItem[@type='host']/@xlink:href
        for $constituent in $model("selected-issue-constituents")
         let $label := bmtneer:format-element($constituent, "constituent-listing-label")
        return
            <li>
                <a href="catalog.html?titleURN={$titleURN}&amp;issueURN={$issueURN}&amp;constituentID={$constituent/@ID/string()}">
                { $label }
                </a>
                </li>
    }</ol>
};

declare function app:selected-issue-constituents-table($node as node(), $model as map(*))
as element()
{
    <table class="table">{
        
        let $issueURN := $model("selected-issue")//mods:identifier[@type='bmtn']
        let $titleURN := $model("selected-issue")//mods:relatedItem[@type='host']/@xlink:href
        for $constituent in $model("selected-issue-constituents")
        let $xsl := doc("/db/apps/bmtneer/resources/xsl/entry.xsl")
        let $xslt-parameters := 
            <parameters>
                <param name="context" value="constituent-listing-table"/>
                <param name="titleURN" value="{ xs:string($titleURN) }" />
                <param name="issueURN" value="{ xs:string($issueURN) }" />
                <param name="veridianLink" value="{bmtneer:veridian-url-from-bmtnid($issueURN)}"/>
            </parameters>
        let $row := transform:transform($constituent, $xsl, $xslt-parameters)
        return
            $row
    }</table>
};



declare function app:selected-issue-label($node as node(), $model as map(*))
as element()*
{
    bmtneer:format-element($model("selected-issue")//mods:mods, "selected-issue-label")
};

declare function app:issue-volume($node as node(), $model as map(*))
as xs:string*
{
    let $issue := $model("selected-issue")
    let $label := string($issue//mods:part[@type='issue']/mods:detail[@type='volume']/mods:number)
    return $label
};

declare function app:issue-number($node as node(), $model as map(*))
as xs:string*
{
    let $issue := $model("selected-issue")
    return  string($issue//mods:part[@type='issue']/mods:detail[@type='number']/mods:number[1])
};

declare function app:issue-pubDate($node as node(), $model as map(*))
as xs:string*
{
    let $issue := $model("selected-issue")
    return string($issue//mods:originInfo/mods:dateIssued[@keyDate='yes'])
};

declare function app:selected-constituent-label($node as node(), $model as map(*))
as element()*
{   
    bmtneer:format-element($model("selected-constituent"), "selected-constituent-label")
};

declare %templates:wrap function app:selected-constituent-creators($node as node(), $model as map(*))
as xs:string*
{
    bmtneer:format-element($model("selected-constituent"), "selected-constituent-creators" )
};

declare %templates:wrap function app:selected-constituent-title($node as node(), $model as map(*))
as xs:string*
{
    bmtneer:format-element($model("selected-constituent"), "selected-constituent-title" )
};

declare function app:w3cdtf-to-xsdate($d as xs:string) as xs:date
{
  let $dstring :=
  if ($d castable as xs:gYear) then $d || "-01-01"
  else if ($d castable as xs:gYearMonth) then $d || "-01"
  else if ($d castable as xs:date) then $d
  else error($d, "not valid w3cdtf")
  return xs:date($dstring)
};

declare function local:altodoc($metsdoc as node(), $id as node()) 
as xs:string {
    let $metsuri := document-uri(root($metsdoc) )
    let $tokens := tokenize($metsuri, '/')
    let $base := subsequence($tokens, 1, count($tokens) - 1)
    let $altohref := substring-after($metsdoc//mets:file[@ID = $id]/mets:FLocat/@xlink:href/string(), 'file://./alto/')
    let $foo := insert-before($base, count($base) + 1, ("alto", $altohref))
    return string-join($foo, '/')
};

declare function local:alto2txt($textblock) {
    for $string in $textblock//alto:String
    return $string/@CONTENT/string()
};

declare function local:alto2html($textblock) {
    <div class="TextBlock"> {
        for $textline in $textblock/alto:TextLine
        let $strings := for $string in $textline/alto:String
                        return $string/@CONTENT/string()
        return (<br/>, $strings)
    } </div>
};


declare function app:search($node as node(), $model as map(*), $searchexpr as xs:string?)
{
    let $result :=
        if ($searchexpr) then
            for $hit in collection($config:transcription-root)//tei:ab[ft:query(., $searchexpr)]
            order by ft:score($hit) descending
            return $hit
        else ()
     return
        map { "search-result" := $result }
};

declare function app:hit-count($node as node(), $model as map(*)) as xs:integer
{
    count($model("search-result"))
};

declare function app:hit-table($node as node(), $model as map(*))
{
    <table class="table">
        <tr><th>score</th><th>magazine</th><th>date</th><th>hit</th></tr>
        {
            for $result in $model("search-result")

            let $issueURN := $result/ancestor::tei:TEI//tei:idno[ @type="bmtnid" ]
            let $constituentID := $result/ancestor::tei:div/@corresp
            let $monogr := $result/ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr
            let $title := $monogr/tei:title/tei:seg[@type='main']
            return
                <tr>
                    <td>{ft:score($result)}</td>
                    <td><a href="constituent.html?issueURN={$issueURN}&amp;constituentID={$constituentID}">{$title}</a></td>
                    <td>{string($monogr/tei:imprint/tei:date/@when)}</td>
                    <td>{kwic:summarize($result, <config width="40"/>)}</td>
                </tr>
        }
     </table>
};