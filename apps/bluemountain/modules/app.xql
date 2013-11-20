xquery version "3.0";

module namespace app="http://bluemountain.princeton.edu/bmtn/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://bluemountain.princeton.edu/bmtn/config" at "config.xqm";

declare namespace mets="http://www.loc.gov/METS/";
declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace xlink="http://www.w3.org/1999/xlink";

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

declare %templates:wrap function app:selected-issue($node as node(), $model as map(*), $issueURN as xs:string?)
as map(*)? 
{
    if ($issueURN) then
        let $issueRec := collection('/db/bluemtn/metadata/periodicals')//mods:identifier[@type='bmtn' and . = $issueURN]/ancestor::mods:mods
        return map { "selected-issue" := $issueRec }    
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
        return $issue
    return map { "selected-title-issues" := $issues }
};

declare function app:selected-issue-constituents($node as node(), $model as map(*))
as map(*)
{
    map { "selected-issue-constituents" := $model("selected-issue")/mods:relatedItem[@type='constituent'] }    
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
            <a href="catalog.html?titleURN={$titleURN}">{$tstring}</a>
           </li>
    }</ol>
};

declare function app:selected-title-issue-listing($node as node(), $model as map(*))
as element()
{
    <ol class="issue-listing">{
        let $titleURN := $model("selected-title")/mods:identifier[@type='bmtn']
        for $issue in $model("selected-title-issues")
        let $issueURN := $issue/mods:identifier[@type='bmtn']
        return
            <li><a href="catalog.html?titleURN={$titleURN}&amp;issueURN={ $issueURN }">{$issueURN}</a></li>
    }</ol>
};

declare function app:selected-issue-constituents-listing($node as node(), $model as map(*))
as element()
{
    <ol class="constituent-listing">{
        for $constituent in $model("selected-issue-constituents")
        let $label := $constituent/@ID/string()
        return
            <li>{ $label }</li>
    }</ol>
};

declare function app:selected-title-label($node as node(), $model as map(*))
as element()*
{
    let $selected-title := $model("selected-title")
    let $xsl := doc("/db/apps/bluemountain/resources/xsl/entry.xsl")
    let $xslt-parameters := 
        <parameters>
            <param name="context" value="selected-title-label"/>
        </parameters>
    return transform:transform($selected-title, $xsl, $xslt-parameters)
};

declare function app:selected-issue-label($node as node(), $model as map(*))
as element()*
{
    let $selected-issue := $model("selected-issue")
    let $xsl := doc("/db/apps/bluemountain/resources/xsl/entry.xsl")
    let $xslt-parameters := 
        <parameters>
            <param name="context" value="selected-issue-label"/>
        </parameters>
    return transform:transform($selected-issue, $xsl, $xslt-parameters)
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

