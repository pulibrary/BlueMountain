xquery version "3.0";

import module namespace config="http://bluemountain.princeton.edu/springs/config" at "config.xqm";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";



let $bmtnid := request:get-parameter("bmtnid", ())
let $titleURN := concat('urn:PUL:bluemountain:', $bmtnid)
let $titleRec := collection('/db/bluemtn')//mods:mods[mods:identifier[@type='bmtn'] = $titleURN]
let $issues := collection('/db/bluemtn')//mods:mods[mods:relatedItem[@type='host']/@xlink:href = $titleURN]
return
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>{$bmtnid}</title>
    </head>
    <body>
    <nav>
        <ol>
            <li><a href="../titles">Blue Mountain Titles</a></li>
        </ol>
    </nav>
        <header>
        <h1>{$titleRec/mods:titleInfo[1]/mods:title[1]}</h1>
        </header>
        <section>
        <p>Blue Mountain has {count($issues)} issue(s).</p>
        <ol>
        {
            for $issue in $issues
            let $label := $issue/mods:originInfo/mods:dateIssued[1]
            let $date := $issue/mods:originInfo/mods:dateIssued[@keyDate='yes']
            let $issueID := $issue/mods:identifier[@type='bmtn']
            order by $date
            return <li><a href="../issues/{substring-after($issueID, 'urn:PUL:bluemountain:')}">{$label}</a></li>
        }
        </ol>
    </section>
    </body>
</html>