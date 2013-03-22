xquery version "3.0";

module namespace app="urn:PUL:bluemountain:apps:bluemtneer/templates";
declare namespace mods="http://www.loc.gov/mods/v3";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm" ;


declare %templates:wrap function app:catEntry($node as node(), $model as map(*), $bmtnid as xs:string?) {
    let $entry :=
        if ($bmtnid) then
            collection($config:data-root)//mods:mods[./mods:identifier = "urn:PUL:bluemountain:" || $bmtnid]
        else
            ()
    return map:entry("title", $entry)
};

(:~
 : This function puts title-level MODS into the Model.
 : There is a bug here
 : @param $node the HTML node with the class attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)
declare
    %templates:wrap
function app:titles($node as node(), $model as map(*)) as map(*) {
    let $titleSet :=
        for $rec in collection($config:data-root)//mods:mods
        where empty($rec/mods:relatedItem[@type='host'])
        order by upper-case($rec/mods:titleInfo[empty(@type)]/mods:title/string())
        return $rec
    return map { "titles" := $titleSet }
};

declare
    %templates:wrap
function app:print-title($node as node(), $model as map(*)) {
    let $titleInfo := $model("title")/mods:titleInfo[empty(@type)]
    let $tstring :=
        if ($titleInfo/mods:nonSort)
        then concat($titleInfo/mods:nonSort/string(), " ")
        else ""
    let $tstring := $tstring || $titleInfo/mods:title/string()
    return $tstring 
};

declare 
    %templates:wrap 
function app:print-identifier($node as node(), $model as map(*)) {
    let $bmtnid := substring-after($model("title")/mods:identifier/string(), 'urn:PUL:bluemountain:')
    let $href := "catalog.html?bmtnid=" || $bmtnid
    return
        <a href="{$href}">
         { $bmtnid }
        </a>
};

declare 
    %templates:wrap 
function app:print-bbid($node as node(), $model as map(*)) {
    let $bbid := substring-after($model("title")//mods:recordOrigin/string(), "BBID=")
    let $prefix := "http://diglib.princeton.edu/tools/ib/pudl0097/"
    return <a href="{$prefix || $bbid}">{ $bbid }</a>
};

declare
    %templates:wrap
function app:print-originInfo($node as node(), $model as map(*)) {
    let $originInfo := $model("title")/mods:originInfo
    let $dateString := $originInfo/mods:dateIssued[@point='start']/string()
    let $dateString :=
        if ($originInfo/mods:dateIssued[@point='end']) then
            $dateString || "&#8212;" || $originInfo/mods:dateIssued[@point='end']/string()
        else
            $dateString
    return $dateString          
};

declare
    %templates:wrap
function app:issues($node as node(), $model as map(*)) {
    let $titleRecId := $model("title")/mods:recordInfo/mods:recordIdentifier
    let $issues := collection($config:data-root)//mods:mods[./mods:relatedItem[@type='host']/mods:recordInfo/mods:recordIdentifier
        = $titleRecId]
        return map:entry("issues", $issues)
};

declare
    %templates:wrap
function app:print-issue-count($node as node(), $model as map(*)) {
    let $count := count($model("issues"))
    let $str := $count || " "
    let $str :=
        if ($count = 1) then
            $str || "issue"
        else $str || "issues"
    return $str
};

declare function app:_format-issuance($partInfo as node())
{
    if ($partInfo/mods:text) then
        $partInfo/mods:text
    else
        let $volInfo := $partInfo/mods:detail[@type='volume']
        let $numInfo := $partInfo/mods:detail[@type='number']
        let $str :=
            if ($volInfo/mods:caption) then
                $volInfo/mods:caption || "; "
            else ""
        let $str :=
            $str || $numInfo/mods:caption
        return $str
};

declare function app:_format-title($titleInfo as node()) as xs:string
{
   let $titleString :=
       if ($titleInfo/mods:nonSort) then
          $titleInfo/mods:nonSort/string() || " "
       else ""
   let $titleString :=
       $titleString || $titleInfo/mods:title/string()
   let $titleString :=
       if ($titleInfo/mods:subTitle) then
          $titleString || ": " || $titleInfo/mods:subTitle/string()
       else
          $titleString
   return $titleString
};

declare
    %templates:wrap
function app:print-issue-info($node as node(), $model as map(*)) {
    if ($model("issue")) then
        let $titleInfo := $model("issue")/mods:titleInfo[empty(@type)]
        let $titleString :=
            if ($titleInfo/mods:nonSort) then
                $titleInfo/mods:nonSort/string() || " "
            else ""
        let $titleString :=
            $titleString || $titleInfo/mods:title/string()
        let $titleString :=
            if ($titleInfo/mods:subTitle) then
                $titleString || ": " || $titleInfo/mods:subTitle/string()
            else
                $titleString
    
        let $partInfo := $model("issue")/mods:part[@type='issue']
        let $issuance := app:_format-issuance($partInfo)
        let $originInfo := $model("issue")/mods:originInfo
        let $dateString := $originInfo/mods:dateIssued[empty(@encoding)]/string()
        return 
            <hgroup>
                <h2>{ $titleString }</h2>
                <p>{ $issuance }</p>
                <p>{ $dateString }</p>
            </hgroup>
    else
        ""
};

declare
    %templates:wrap
function app:issue-list($node as node(), $model as map(*)) {
    for $issue in $model("issues")
    let $id := $issue/mods:identifier/string()
    let $dateString := $issue/mods:originInfo/mods:dateIssued[empty(@encoding)]/string()
    return
        <li>{ $id  || ' ' ||  $dateString }</li>
};
declare
    %templates:wrap
function app:issue-form($node as node(), $model as map(*)) {
    let $bmtnid := substring-after($model("title")/mods:identifier/string(), 'urn:PUL:bluemountain:')
    return
        <form action="">
            <select name="issueid">
            {
                for $issue in $model("issues")
                let $id := $issue/mods:identifier/string()
                let $dateString := $issue/mods:originInfo/mods:dateIssued[empty(@encoding)]/string()
                return
                    <option value="{ $id }">{ $dateString }</option>
            }
            </select>
            <input type="hidden" name="bmtnid" id="bmtnid" value="{ $bmtnid }"/>
            <input type="submit" value="Browse Issue"/>
        </form>

};

declare
    %templates:wrap
function app:issue-option($node as node(), $model as map(*)) {
    let $issueDate := $model("issue")/mods:originInfo/mods:dateIssued[empty(@encoding)]/string()
    let $issueID   := $model("issue")/mods:identifier/string()
    return <option value="{ $issueID }">{ $issueDate }</option>
};

declare
    %templates:wrap
function app:issue($node as node(), $model as map(*), $issueid as xs:string?) {
    let $issue :=
        if ($issueid) then
            collection($config:data-root)//mods:mods[./mods:identifier = $issueid]
        else
            ()
    return map:entry("issue", $issue)
};

declare
    %templates:wrap
function app:issue-constituents($node as node(), $model as map(*)) {
    let $constituents := $model("issue")/mods:relatedItem[@type='constituent']
    return map:entry("issue-constituents", $constituents)
};

declare
    %templates:wrap
function app:print-constituent-title($node as node(), $model as map(*)) {

  app:_format-title($model("item")/mods:titleInfo)
};

declare
    %templates:wrap
function app:print-constituent-byline($node as node(), $model as map(*)) {
    let $names := 
     for $name in $model("item")/mods:name
     return app:encode-name($name)
    return
      <span>
       {
         for $name in $names return $name || " "
       }
      </span>
};

declare function app:encode-name($name as node()) {
 let $displayForm :=
   if ($name/mods:displayForm) then
    $name/mods:displayForm/string()
   else if ($name/mods:namePart[@type='family']) then
    $name/mods:namePart[@type='family']/string()
   else $name/mods:namePart[1]/string()
   
 return <span class="{$name/@type} name">{ $displayForm }</span>
};

declare
    %templates:wrap
function app:print-toc($node as node(), $model as map(*)) {
    for $item at $pos in $model("issue-constituents")
    let $title := 
        if ($item/mods:titleInfo) then
            app:_format-title($item/mods:titleInfo[1])
        else "[untitled]"
    let $names := for $n in $item/mods:name return app:encode-name($n)
    let $rank := if ($pos mod 2 = 0) then "even" else "odd"
    return
        <li class="listing {$rank}">
            <dl>
                <dt class="title">{ $title }</dt>
                <dd class="byline">
               {
                    for $n in $names
                    let $sep := if ($n = $names[last()]) then "" else ", "
                    return ($n, $sep)
                }                    
                </dd>
            </dl>
         </li>        
};





