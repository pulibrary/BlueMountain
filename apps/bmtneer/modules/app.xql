xquery version "3.0";

module namespace app="http://blaueberg.info/bmtneer/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://blaueberg.info/bmtneer/config" at "config.xqm";
import module namespace bmtneer="http://blaueberg.info/bmtneer" at "bmtneer-module.xqm";

declare namespace mets="http://www.loc.gov/METS/";
declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace alto="http://www.loc.gov/standards/alto/ns-v2#";

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
        for $rec in collection('/db/bluemtn/metadata/periodicals')//mods:mods[empty(mods:relatedItem[@type='host'])]
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
        order by $date
        return $issue
    return map { "selected-title-issues" := $issues }
};

declare function app:selected-title-listing($node as node(), $model as map(*))
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
(: 
 : ISSUE TEMPLATES
 :)

declare %templates:wrap function app:selected-issue($node as node(), $model as map(*), $issueURN as xs:string?)
as map(*)? 
{
    if ($issueURN) then
        let $issueRec := collection('/db/bluemtn/metadata/periodicals')//mods:identifier[@type='bmtn' and . = $issueURN]/ancestor::mods:mods
        return map { "selected-issue" := $issueRec }    
     else ()
};

declare function app:selected-issue-constituents($node as node(), $model as map(*))
as map(*)
{
    map { "selected-issue-constituents" := $model("selected-issue")/mods:relatedItem[@type='constituent'] }    
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

    let $volnum := $issueByVolume/mods:part[@type='issue']/mods:detail[@type='volume']/mods:number[1]
    let $issuenum := $issueByVolume/mods:part[@type='issue']/mods:detail[@type='number']/mods:number
    let $date := $issueByVolume/mods:originInfo/mods:dateIssued[@keyDate='yes']
    order by xs:integer($volnum[1]),xs:integer($issuenum)
    return
        <tr>
            <td>{$volnum[1]/text()}</td>
            <td>{$issuenum/text()}</td>
            <td>{$date/text()}</td>
            <td><a href="issue.html?titleURN={$titleURN}&amp;issueURN={ $issueURN }">detail</a></td>
        </tr>
    }</table>
};

declare function app:selected-title-issue-listing-group($node as node(), $model as map(*))
as element()*
{
  for $issueByVolume in $model("selected-title-issues")  
  group by $volnum := $issueByVolume/mods:part[@type='issue']/mods:detail[@type='volume']/mods:number
  order by $volnum
  return
        <ul>
            <li>
                <h3>Volume { $volnum/text() }</h3>
                <ul>
                {
                    for $issue in $issueByVolume
                    group by $issuenum := $issue/mods:part[@type='issue']/mods:detail[@type='number']/mods:number
                    order by $issuenum
                    return
                        <li>Number { $issuenum }</li>
                }    
                </ul>
            </li>  
        </ul>
};

declare function app:selected-title-issue-listing-thunk($node as node(), $model as map(*))
as element()
{
    <ol class="issue-listing">{
        for $issue in $model("selected-title-issues")
        let $issueURN := $issue/mods:identifier[@type='bmtn']/string()
        let $titleURN := $issue/mods:relatedItem[@type='host']/@xlink:href
        let $volnum   := $issue/mods:part[@type='issue']/mods:detail[@type='volume']/mods:number
        let $issuenum := $issue/mods:part[@type='issue']/mods:detail[@type='number']/mods:number
        let $xsl := doc("/db/apps/bmtneer/resources/xsl/entry.xsl")
        let $xslt-parameters := 
            <parameters>
                <param name="context" value="issue-listing-label"/>
            </parameters>
        let $label := transform:transform($issue, $xsl, $xslt-parameters)
        group by $volnum
        order by $volnum
        return
            <li><h3>{$volnum/text()}</h3>
                <ol>
                    <li><a href="issue.html?titleURN={$titleURN}&amp;issueURN={ $issueURN }">{$label}</a>
                
            </li>
                </ol>
            </li>
            
    }</ol>
};

declare function app:selected-title-issue-listing-old($node as node(), $model as map(*))
as element()
{
    <ol class="issue-listing">{
        for $issue in $model("selected-title-issues")
        let $issueURN := $issue/mods:identifier[@type='bmtn']/string()
        let $titleURN := $issue/mods:relatedItem[@type='host']/@xlink:href
        let $xsl := doc("/db/apps/bmtneer/resources/xsl/entry.xsl")
        let $xslt-parameters := 
            <parameters>
                <param name="context" value="issue-listing-label"/>
            </parameters>
        let $label := transform:transform($issue, $xsl, $xslt-parameters)
        return
            <li><a href="catalog.html?titleURN={$titleURN}&amp;issueURN={ $issueURN }">{$label}</a>
                <br/><a href="{bmtneer:veridian-url-from-bmtnid($issueURN)}">stuff</a>
            </li>
    }</ol>
};

(: 
 : Constituent Templates
 :)

declare %templates:wrap function app:selected-constituent($node as node(), $model as map(*), $titleURN as xs:string?, $issueURN as xs:string?, $constituentID as xs:string?)
as map(*)? 
{
    if ($issueURN and $titleURN and $constituentID) then
        let $issueRec := collection('/db/bluemtn/metadata/periodicals')//mods:identifier[@type='bmtn' and . = $issueURN]/ancestor::mods:mods
        let $titleRec := collection('/db/bluemtn/metadata/periodicals')//mods:identifier[@type='bmtn' and .= $titleURN]/ancestor::mods:mods
        let $constituent-r-item := $issueRec/mods:relatedItem[@ID = $constituentID]
        let $mets := $issueRec/ancestor::mets:mets
        let $logicalDiv := $issueRec/ancestor::mets:mets/mets:structMap[@TYPE='LOGICAL']//mets:div[@DMDID = $constituentID]
        let $plaintext :=
            for $area in $logicalDiv//mets:area
            let $adoc := local:altodoc($mets, $area/@FILEID)
            return local:alto2txt(doc($adoc)//node()[@ID = $area/@BEGIN])
        return map { "selected-constituent-text" := $plaintext, "selected-constituent" := $constituent-r-item, "selected-title" := $titleRec }
     else ()
};

declare function app:selected-constituent-contents($node as node(), $model as map(*))
{
  $model("selected-constituent-text")  
};



declare function app:selected-issue-constituents-listing($node as node(), $model as map(*))
as element()
{
    <ol class="constituent-listing">{
        
        let $issueURN := $model("selected-issue")/mods:identifier[@type='bmtn']
        let $titleURN := $model("selected-issue")/mods:relatedItem[@type='host']/@xlink:href
        for $constituent in $model("selected-issue-constituents")
        let $label-old := $constituent/@ID/string()
        let $xsl := doc("/db/apps/bmtneer/resources/xsl/entry.xsl")
        let $xslt-parameters := 
            <parameters>
                <param name="context" value="constituent-listing-label"/>
            </parameters>
        let $label := transform:transform($constituent, $xsl, $xslt-parameters)
        return
            <li>
                <a href="catalog.html?titleURN={$titleURN}&amp;issueURN={$issueURN}&amp;constituentID={$constituent/@ID/string()}">
                { $label }
                </a>
                </li>
    }</ol>
};


declare function app:selected-issue-label($node as node(), $model as map(*))
as element()*
{
    let $selected-issue := $model("selected-issue")
    let $xsl := doc("/db/apps/bmtneer/resources/xsl/entry.xsl")
    let $xslt-parameters := 
        <parameters>
            <param name="context" value="selected-issue-label"/>
        </parameters>
    return transform:transform($selected-issue, $xsl, $xslt-parameters)
};

declare function app:selected-constituent-label($node as node(), $model as map(*))
as element()*
{
 (:<h2>{ $model("selected-constituent")/mods:titleInfo/mods:title/text() }</h2> :)
 let $selected-constituent := $model("selected-constituent")
    let $xsl := doc("/db/apps/bmtneer/resources/xsl/entry.xsl")
    let $xslt-parameters := 
        <parameters>
            <param name="context" value="selected-constituent-label"/>
        </parameters>
    return transform:transform($selected-constituent, $xsl, $xslt-parameters)
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