xquery version "3.0";

module namespace bmtneer="http://bluemountain.princeton.edu/modules/bmtneer";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://bluemountain.princeton.edu/config" at "config.xqm";
import module namespace app="http://bluemountain.princeton.edu/modules/app" at "app.xql";
import module namespace issue="http://bluemountain.princeton.edu/modules/issue" at "issue.xqm";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace xlink="http://www.w3.org/1999/xlink";

declare %templates:wrap function bmtneer:bylines($node as node(), $model as map(*))
as map(*)
{
    let $displayForms := collection($config:data-root)//mods:displayForm
(:     let $bylines := distinct-values($displayForms) :)
(:     return map { "bylines" := $bylines }  :)
    return map { "bylines" := $displayForms }
};

declare %templates:wrap function bmtneer:bylines-listing-1($node as node(), $model as map(*))
as element()
{
    <span>
        {
            for $byline in $model("bylines") return $byline
        }
    </span> 
};

declare %templates:wrap function bmtneer:bylines-listing($node as node(), $model as map(*))
as element()
{
    let $all-bylines := $model("bylines") 
    let $bylines := distinct-values($all-bylines)
    return
        <span> {
            for $byline in $bylines
            let $count := count(ft:query($all-bylines, $byline))
            let $font-size := 
                if ($count = 1) then "smaller"
                else if ($count < 4) then "small"
                else if ($count < 8) then "medium"
                else if ($count < 12) then "large"
                else "x-large"
            return 
                <span style="font-size: {$font-size}"> {
                ($byline, $count )
                } </span>
        } </span>
        
};

declare function bmtneer:content-by($node as node(), $model as map(*), $byline as xs:string)
as element()
{
    let $hits := collection($config:data-root)//mods:displayForm[. = $byline]/ancestor::mods:relatedItem[@type = 'constituent']
    return map { "content" := $hits  }
};

