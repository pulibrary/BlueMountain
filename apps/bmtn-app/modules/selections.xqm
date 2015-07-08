xquery version "3.0";

module namespace selections="http://bluemountain.princeton.edu/modules/selections";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://bluemountain.princeton.edu/config" at "config.xqm";
import module namespace app="http://bluemountain.princeton.edu/modules/app" at "app.xql";
import module namespace kwic="http://exist-db.org/xquery/kwic";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace tei="http://www.tei-c.org/ns/1.0";


declare %templates:wrap function selections:selected-items-mods($node as node(), $model as map(*), 
                                                           $query as xs:string?, $byline as xs:string*,
                                                           $magazine as xs:string*)
as map(*)? 
{
    let $name-hits  := 
        if ($query !='')
            then collection($config:data-root)//mods:relatedItem[ft:query(.//mods:displayForm, $query)]
         else ()
    let $title-hits := 
        if ($query != '')
        then collection($config:data-root)//mods:relatedItem[ft:query(.//mods:titleInfo, $query)]
        else ()
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
    let $hits :=
        if ($magazine)
        then $hits[./ancestor::mods:mods/mods:relatedItem[@type='host']/@xlink:href = $magazine]
        else $hits

    return map { "selected-items" : $hits, "query" : $query }    
};

declare %templates:wrap function selections:selected-items($node as node(), $model as map(*), 
                                                           $query as xs:string?, $byline as xs:string*,
                                                           $magazine as xs:string*)
as map(*)? 
{
    let $transcription-db := "/db/bluemtn/transcriptions"
    let $name-hits  := 
        if ($query !='')
            then collection($transcription-db)//tei:relatedItem[ft:query(.//tei:persName, $query)]
         else ()
    let $title-hits := 
        if ($query != '')
            then collection($transcription-db)//tei:relatedItem[ft:query(.//tei:title, $query)]
         else ()
    let $ft-hits :=
        if ($query != '')
            then collection($transcription-db)//tei:ab[ft:query(., $query)]
        else ()
    let $restrictions :=
        if ($byline != '')
        then 
            for $line in $byline return 
        collection($transcription-db)//tei:relatedItem[ft:query(.//tei:persName, $line)]
        else ()
    
    
    let $query-hits := $name-hits union $title-hits
    let $hits :=
        if ($restrictions)
        then $query-hits intersect $restrictions
        else $query-hits
    let $hits :=
        if ($magazine)
        then $hits[./ancestor::tei:TEI//tei:relatedItem[@type='host']/@target = $magazine]
        else $hits

    return map { "selected-items" : $hits, "query" : $query, "ft-hits" : $ft-hits }    
};

declare function selections:foo-mods($node as node(), $model as map(*))
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
             let $title := collection($config:data-root)//mods:mods[./mods:identifier = $mag]/mods:titleInfo[1]/mods:title[1]/text()
             let $count := count($mags[.= $mag])
             order by $count descending
             return
                <li><input type="checkbox" name="magazine" value="{$mag}">{$title} ({$count})</input></li>
            }
        </ol>
       </fieldset>
        <input type="submit" value="Search"/>
    </form>
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
           let $names := $model("selected-items")//tei:persName
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
            let $mags := $model("selected-items")/ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:relatedItem[@type='host']/@target
                         union
                         $model("ft-hits")/ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:relatedItem[@type='host']/@target
            for $mag in distinct-values($mags)
             let $title := collection($config:data-root)//mods:mods[./mods:identifier = $mag]/mods:titleInfo[1]/mods:title[1]/text()
             let $count := count($mags[.= $mag])
             order by $count descending
             return
                <li><input type="checkbox" name="magazine" value="{$mag}">{$title} ({$count})</input></li>
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
as element()*
{
    let $items := $model("selected-items")
   for $item in $items return
                <li>{ selections:formatted-item($item) }</li>
};

declare function selections:formatted-item-mods($item as element())
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

declare function selections:formatted-item($item as element())
{
    let $nonSort :=
        if ($item/tei:biblStruct/tei:analytic/tei:title/tei:seg[@type='nonSort'])
        then $item/tei:biblStruct/tei:analytic/tei:title/tei:seg[@type='nonSort']/text()
        else ()
    let $title :=
        if ($item/tei:biblStruct/tei:analytic/tei:title/tei:seg[@type='main'])
        then $item/tei:biblStruct/tei:analytic/tei:title/tei:seg[@type='main']/text()
        else ()
    let $subtitle :=
        if ($item/tei:biblStruct/tei:analytic/tei:title/tei:seg[@type='sub'])
        then string-join((':', $item/tei:biblStruct/tei:analytic/tei:title/tei:seg[@type='sub']/text()), ' ')
        else ()
    let $names :=
        if ($item//tei:persName)
        then
            for $name in $item//tei:persName return $name/text()
        else ()
    let $journal := $item/ancestor::tei:sourceDesc/tei:biblStruct/tei:monogr
    let $journalTitle :=
        $journal/tei:title/tei:seg[@type='main']/text()
    let $volume :=
        if ($journal/tei:imprint/tei:biblScope[@unit='vol'])
        then concat("Vol. ", $journal/tei:imprint/tei:biblScope[@unit='vol'])
        else ()
    let $number :=
        if ($journal/tei:imprint/tei:biblScope[@unit='issue'])
        then concat("No. ", $journal/tei:imprint/tei:biblScope[@unit='issue']/text())
        else ()
    let $date := xs:string($journal/tei:imprint/tei:date/@when)
    (: let $issueLink := app:veridian-url-from-bmtnid($journal/mods:identifier[@type='bmtn']) :)
    let $issueLink := concat('issue.html?issueURN=',$journal/ancestor::tei:teiHeader/tei:publicationStmt/tei:idno[@type='bmtnid'])
        
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

declare  %templates:wrap function selections:full-text-KWIC($node as node(), $model as map(*))
as element()*
{
 let $hits := $model("ft-hits")
 for $hit in $hits
     let $summary := kwic:summarize($hit, <config width="40" />)
     let $corresp := $hit/ancestor::tei:div/@corresp[1]
     let $constituent := $hit/ancestor::tei:TEI//tei:relatedItem[@xml:id = $corresp][1]
     let $ref :=
        if ($constituent)
        then selections:formatted-item($constituent)
        else "unknown"
    order by ft:score($hit) descending
    return
    (<dt>{$ref}</dt>,
    <dd>{$summary}</dd>)
};