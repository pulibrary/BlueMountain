xquery version "3.0";

module namespace selections="http://bluemountain.princeton.edu/modules/selections";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://bluemountain.princeton.edu/config" at "config.xqm";
import module namespace app="http://bluemountain.princeton.edu/modules/app" at "app.xql";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";

declare %templates:wrap function selections:selected-items-old($node as node(), $model as map(*), 
$anywhere as xs:string?, $byline as xs:string?
)
as map(*)? 
{
    let $hits :=
    
    if ($byline) 
    then collection($config:data-root)//mods:relatedItem[ft:query(.//mods:displayForm, $byline)]
    else if ($anywhere) then collection($config:data-root)//mods:relatedItem[ft:query(.//mods:displayForm, $anywhere)
                                                                   or ft:query(.//mods:titleInfo, $anywhere)]
    else ()
        return map { "selected-items" := $hits }    
};

declare %templates:wrap function selections:selected-items($node as node(), $model as map(*), $query as xs:string?, $byline as xs:string*)
as map(*)? 
{
    let $name-hits  := collection($config:data-root)//mods:relatedItem[ft:query(.//mods:displayForm, $query)]
    let $title-hits := collection($config:data-root)//mods:relatedItem[ft:query(.//mods:titleInfo, $query)]
    let $restrictions :=
        if ($byline != '')
        then 
            for $line in $byline return 
        collection($config:data-root)//mods:relatedItem[ft:query(.//mods:displayForm, $line)]
        else ()
    
    let $query-hits := $name-hits union $title-hits
    let $hits :=
        if ($restrictions)
        then $query-hits intersect $restrictions
        else $query-hits

    return map { "selected-items" : $hits, "query" : $query }    
};

declare %templates:wrap function selections:foo($node as node(), $model as map(*))
{
    <form action="">
        <label for="thequery">Query Terms: </label>
        <input name="query" id="query" value="{$model('query')}"/>
        <br/>
       <fieldset>
        <legend>with byline</legend>
        <ol>
        {
           let $names := $model("selected-items")//mods:displayForm
           let $normalized-names := for $name in $names return normalize-space(lower-case($name))
           for $name in distinct-values($normalized-names, "?strength=primary") 
                let $count := count($normalized-names[.= $name])
                order by $count descending
                return <li><input type="checkbox" name="byline" value="{$name}">{$name} ({$count})</input></li>  
        }
        </ol>
       </fieldset>
       <fieldset>
        <legend>in magazine</legend>
        <ol>
            {
            let $mags := $model("selected-items")/ancestor::mods:mods/mods:relatedItem[@type='host']/@xlink:href
            for $mag in distinct-values($mags)
            return
                <li>{$mag}</li>
            }
        </ol>
       </fieldset>
        <input type="submit" value="Search"/>
    </form>
};

declare function local:name-link($name as xs:string) as element()
{
    <a href="selections.html?byline=&quot;{replace($name, ' ', '+')}&quot;">{ $name }</a>
};

declare %templates:wrap function selections:name-facet($node as node(), $model as map(*))
{
    let $names := $model("selected-items")//mods:displayForm
    let $normalized-names := for $name in $names return normalize-space(lower-case($name))
    return
        <ol>
            {
                for $name in distinct-values($normalized-names, "?strength=primary") 
                let $count := count($normalized-names[.= $name])
                order by $count descending
                return <li>{ local:name-link($name) } ({$count})</li>
            }
        </ol>
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