xquery version "3.0";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

declare variable $tokens := tokenize($exist:path, '/');

if ($exist:path eq "/") then
    (: forward root path to index.xql :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="index.html"/>
    </dispatch>
else if (ends-with($exist:resource, ".html")) then
    (: the html page is run through view.xql to expand templates :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
		<error-handler>
			<forward url="{$exist:controller}/error-page.html" method="get"/>
			<forward url="{$exist:controller}/modules/view.xql"/>
		</error-handler>
    </dispatch>
else if ($exist:resource = "titles") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/titles.xql"/>
    </dispatch>
else if ($tokens[count($tokens) - 1] = "titles") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/title.xql">
            <add-parameter name="bmtnid" value="{$exist:resource}"/>
        </forward>
    </dispatch>
else if ($tokens[count($tokens) - 1] = "issues") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/issue.xql">
            <add-parameter name="bmtnid" value="{$exist:resource}"/>
        </forward>
    </dispatch>
else if ($tokens[count($tokens) - 2] = "constituents-original") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/constituent.xql">
            <add-parameter name="bmtnid" value="{$tokens[count($tokens) - 1]}"/>
            <add-parameter name="constituentid" value="{$exist:resource}"/>
        </forward>
    </dispatch>
    
else if ($tokens[count($tokens) - 2] = "constituents") then
let $constituentid := 
                if (ends-with($exist:resource, ".txt")) then
                substring-before($exist:resource, ".txt")
                else $exist:resource
let $mode :=
                if (ends-with($exist:resource, ".txt")) then
                "txt" else ()
     return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/modules/constituent2.xql">
            <add-parameter name="bmtnid" value="{$tokens[count($tokens) - 1]}"/>
            <add-parameter name="constituentid" value="{$constituentid}"/>
            <add-parameter name="mode" value="{$mode}"/>
            <set-attribute name="xquery.attribute" value="model"/>
        </forward>

        <view>
            <forward servlet ="XSLTServlet">
      <set-attribute name="xslt.stylesheet" value = "{$exist:root}/bmtn_springs/resources/xsl/foo.xsl"/>
      <set-attribute name="xslt.input" value="model"/>
    </forward>

        </view>

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
