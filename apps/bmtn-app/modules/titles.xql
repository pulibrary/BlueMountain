xquery version "3.0";

module namespace titles="http://bluemountain.princeton.edu/modules/titles";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://bluemountain.princeton.edu/config" at "config.xqm";
import module namespace app="http://bluemountain.princeton.edu/modules/app" at "app.xql";

declare namespace mods="http://www.loc.gov/mods/v3";

declare %templates:wrap function titles:all($node as node(), $model as map(*)) 
as map(*) 
{
    let $titleSequence :=
        for $rec in collection($config:data-root)//mods:genre[.='Periodicals-Title']/ancestor::mods:mods
        order by upper-case($rec/mods:titleInfo[empty(@type)]/mods:title/string())
        return $rec
    return map { "titles" := $titleSequence }
};

declare function titles:count($node as node(), $model as map(*)) 
as xs:integer 
{ count($model("titles")) };

declare function titles:listing($node as node(), $model as map(*))
as element()*
{
    let $xsl := doc($config:app-root || "/resources/xsl/titles.xsl")
	return
	<div class="row">
	{ 
		for $title in $model("titles")
		let $xslt-parameters := 
        <parameters>
        <param name="app-root" value="{$config:app-root}"/>
        <param name="veridianLink" value="{app:veridian-title-url-from-bmtnid($title//mods:identifier[@type='bmtn'])}"/>
        </parameters>

		return
		transform:transform($title, $xsl, $xslt-parameters)
	}
	</div>
};
