xquery version "3.0";

module namespace issue="http://bluemountain.princeton.edu/modules/issue";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://bluemountain.princeton.edu/config" at "config.xqm";
import module namespace app="http://bluemountain.princeton.edu/modules/app" at "app.xql";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";


declare %templates:wrap function issue:selected-issue($node as node(), $model as map(*), $issueURN as xs:string?)
as map(*)? 
{
    if ($issueURN) then
        let $issueRec := collection($config:data-root)//mods:mods/mods:identifier[@type='bmtn' and . = $issueURN]/ancestor::mods:mods
        return map { "selected-issue" := $issueRec }    
     else ()
};

declare function issue:constituents($node as node(), $model as map(*))
as map(*)
{
    map { "selected-issue-constituents" := $model("selected-issue")//mods:relatedItem[@type='constituent'] }    
};

declare %templates:wrap function issue:label($node as node(), $model as map(*))
as element()
{
    let $selected-issue := $model("selected-issue")
    let $xsl := doc($config:app-root || "/resources/xsl/issue.xsl")

    return transform:transform($selected-issue, $xsl, ())
};


declare function issue:volume($node as node(), $model as map(*))
as xs:string*
{
    let $issue := $model("selected-issue")
    let $label := string($issue/mods:part[@type='issue']/mods:detail[@type='volume']/mods:number[1])
    return $label
};

declare function issue:number($node as node(), $model as map(*))
as xs:string*
{
    let $issue := $model("selected-issue")
    return  string($issue//mods:part[@type='issue']/mods:detail[@type='number']/mods:number[1])
};

declare function issue:pubDate($node as node(), $model as map(*))
as xs:string*
{
    let $issue := $model("selected-issue")
    return string($issue//mods:originInfo/mods:dateIssued[@keyDate='yes'])
};

declare %templates:wrap function issue:icon($node as node(), $model as map(*))
 as element()
 {
    let $issueURN := $model("selected-issue")//mods:identifier
    let $iconpath := issue:icon-path($issueURN)
    return <img src="{$iconpath}/large.jpg" />
};


declare function issue:icon-path($bmtnURN as xs:string)
as xs:string
{
    let $icon-root := "/exist/rest/" || $config:app-root || "/resources/icons/periodicals/"
    let $bmtnid   := tokenize($bmtnURN, ':')[last()] (: e.g., bmtnaae_1920-03_01 :)
    let $iconpath := replace($bmtnid, '(bmtn[a-z]{3})_([^_]+)_([0-9]+)', '$1/issues/$2_$3') (: e.g., bmtnaae/issues/1920-03_01 :)
    let $iconpath := replace($iconpath, '-', '/')
    return $icon-root || $iconpath
};

declare function issue:constituents-table($node as node(), $model as map(*))
as element()
{
    <table class="table">{
        
        let $issueURN := $model("selected-issue")//mods:identifier[@type='bmtn']
        let $titleURN := $model("selected-issue")//mods:relatedItem[@type='host']/@xlink:href
        for $constituent in $model("selected-issue-constituents")
        let $xsl := doc($config:app-root || "/resources/xsl/issue.xsl")
        let $xslt-parameters := 
            <parameters>
                <param name="context" value="constituent-listing-table"/>
                <param name="titleURN" value="{ xs:string($titleURN) }" />
                <param name="issueURN" value="{ xs:string($issueURN) }" />
                <param name="veridianLink" value="{app:veridian-url-from-bmtnid($issueURN)}"/>
            </parameters>
        let $row := transform:transform($constituent, $xsl, $xslt-parameters)
        return
            $row
    }</table>
};


 
 
 