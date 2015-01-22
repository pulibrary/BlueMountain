xquery version "3.0";

(: constituents controller :)

import module namespace config="http://bluemountain.princeton.edu/config" at "../../modules/config.xqm";

declare namespace fn="http://www.w3.org/2005/xpath-functions";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

declare function local:parse_path()
{
    let $pattern := "^/(.+?)(/([^.]+))?(\.(.+))?$"
    let $analysis := analyze-string($exist:path, $pattern)
    return
        <request>
            <issueid>{ $analysis/fn:match/fn:group[@nr='1']/text() }</issueid>
            <constituentid>{ 
             if ($analysis/fn:match//fn:group[@nr='3']) then
                $analysis/fn:match//fn:group[@nr='3']/text()
             else ()
            }</constituentid>
            <format>{ 
             if ($analysis/fn:match//fn:group[@nr='5']) then
                $analysis/fn:match//fn:group[@nr='5']/text()
             else ()
            }</format>
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

(:   
else if (ends-with($exist:resource, ".html")) then
    (\: the html page is run through view.xql to expand templates :\)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <view>
            <forward url="{$exist:controller}/../../modules/view.xql"/>
        </view>
		<error-handler>
			<forward url="{$exist:controller}/../../error-page.html" method="get"/>
			<forward url="{$exist:controller}/../../modules/view.xql"/>
		</error-handler>
    </dispatch>:)
    
(:else if ($exist:resource) then
    let $parse := local:parse_path()
    return $parse/issueid:)
    
else if ($exist:resource) then
    let $parse := local:parse_path()
    let $issueid := $parse/issueid
    let $constituentid := $parse/constituentid
    let $format := $parse/format
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/constituents.xql">
            <add-parameter name="data-root" value="{$config:data-root}" />
            <add-parameter name="issueid" value="{$issueid}" />
            <add-parameter name="constituentid" value="{$constituentid}" />
        </forward>
        {
        if ($format eq 'txt') then
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet"
                    value="{$exist:root}/{$exist:controller}/resources/xsl/text.xsl"/>
            </forward>
        </view>
        else ()
        }
        
        <error-handler>
            <forward url="{$exist:controller}/../../error-page.html" method="get"/>
            <forward url="{$exist:controller}/../../modules/view.xql"/>
        </error-handler>
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
