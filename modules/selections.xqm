xquery version "3.0";

module namespace selections="http://bluemountain.princeton.edu/modules/selections";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://bluemountain.princeton.edu/config" at "config.xqm";
import module namespace app="http://bluemountain.princeton.edu/modules/app" at "app.xql";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";

declare %templates:wrap function selections:selected-items($node as node(), $model as map(*), 
$anywhere as xs:string?
)
as map(*)? 
{
    if ($anywhere) then
        let $hits := collection($config:data-root)//mods:relatedItem[ft:query(.//mods:displayForm, $anywhere)
                                                                   or ft:query(.//mods:titleInfo, $anywhere)]
        return map { "selected-items" := $hits }    
     else ()
};

declare %templates:wrap function selections:selected-items-old($node as node(), $model as map(*), 
$byline as xs:string?,
$title as xs:string?
)
as map(*)? 
{
    let $items :=
           if ($byline and $title) then
      collection($config:data-root)//mods:relatedItem[ft:query(.//mods:displayForm, $byline) and ft:query(.//mods:titleInfo, $title)]
    else if ($byline) then
        collection($config:data-root)//mods:relatedItem[ft:query(.//mods:displayForm, $byline)]
    else if ($title) then
        collection($config:data-root)//mods:relatedItem[ft:query(.//mods:titleInfo, $title)]
    else ()
    return map { "selected-items" := $items }
};

declare  %templates:wrap function selections:selected-items-listing($node as node(), $model as map(*))
as element()
{
    let $items := $model("selected-items")
    return
        <ol class="selection-list">
            {
                for $item in $items return
                <li>{ selections:formatted-item($item) }</li>
            }
        </ol>
};

declare function selections:formatted-item($item as element())
{
    let $nonSort :=
        if ($item/mods:titleInfo/mods:nonSort)
        then $item/mods:titleInfo/mods:nonSort/text()
        else ()
    let $title :=
        if ($item/mods:titleInfo/mods:title)
        then $item/mods:titleInfo/mods:title/text()
        else ()
    let $subtitle :=
        if ($item/mods:titleInfo/mods:subTitle)
        then string-join((':', $item/mods:titleInfo/mods:subTitle/text()), ' ')
        else ()
    let $names :=
        if ($item/mods:name)
        then
            for $name in $item/mods:name return $name/mods:displayForm/text()
        else ()
    let $journal := $item/ancestor::mods:mods[1]
    let $journalTitle :=
        $journal/mods:titleInfo/mods:title/text()
    let $volume :=
        if ($journal/mods:part[@type='issue']/mods:detail[@type='volume'])
        then concat("Vol. ", $journal/mods:part[@type='issue']/mods:detail[@type='volume']/mods:number[1])
        else ()
    let $number :=
        if ($journal/mods:part[@type='issue']/mods:detail[@type='number'])
        then concat("No. ", $journal/mods:part[@type='issue']/mods:detail[@type='number']/mods:number[1])
        else ()
    let $date := $journal/mods:originInfo/mods:dateIssued[@keyDate = 'yes']
    (: let $issueLink := app:veridian-url-from-bmtnid($journal/mods:identifier[@type='bmtn']) :)
    let $issueLink := concat('issue.html?issueURN=',$journal/mods:identifier[@type='bmtn'])
        
    return
    (<span class="itemTitle">
        {
            string-join(($nonSort,$title,$subtitle), ' ')
        }
    </span>, <br/>,
    <span class="names">
        {
            string-join($names, ', ')
        }
    </span>, <br/>,
    <span class="imprint">
        <a href="{$issueLink}">
        { string-join(($journalTitle,$volume,$number), ', ') } ({ $date })
        </a>
    </span>
    )
};