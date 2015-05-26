xquery version "3.0";

(: expressions controller :)

import module namespace config="http://bluemountain.princeton.edu/config" at "../../modules/config.xqm";

declare namespace fn="http://www.w3.org/2005/xpath-functions";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

declare function local:parse_path()
{
    let $pattern := "^/(.*?)/([^.]+)\.?(.+)?$"
    let $analysis := analyze-string($exist:path, $pattern)
    return
        <request>
            <issueid>{ $analysis/fn:match/fn:group[@nr='1']/text() }</issueid>
            <constituentid>{ $analysis/fn:match/fn:group[@nr='2']/text() }</constituentid>
            <format>{ $analysis/fn:match/fn:group[@nr='3']/text() }</format>
        </request>
};

if ($exist:path eq '') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-uri()}/"/>
    </dispatch>
    
else if ($exist:path eq "/") then
    (: forward root path to index.xql :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="index.html"/>
    </dispatch>

    
 
    
(: Resource paths starting with $shared are loaded from the shared-resources app :)
else if (contains($exist:path, "/$shared/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="/shared-resources/{substring-after($exist:path, '/$shared/')}">
            <set-header name="Cache-Control" value="max-age=3600, must-revalidate"/>
        </forward>
    </dispatch>
else
    (: everything else is passed through :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>
