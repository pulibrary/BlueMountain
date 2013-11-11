xquery version "3.0";

import module namespace config="http://bluemountain.princeton.edu/springs/config" at "config.xqm";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";



let $bmtnid := request:get-parameter("bmtnid", ())
let $issueURN := concat('urn:PUL:bluemountain:', $bmtnid)
let $issueRec := collection('/db/bluemtn')//mods:mods[mods:identifier[@type='bmtn'] = $issueURN]
let $constituents := $issueRec/mods:relatedItem[@type='constituent']

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
        <h1>{$issueRec/mods:titleInfo[1]/mods:title[1]}</h1>
        </header>
        <section>
        <p>This issue has {count($constituents)} constituent(s).</p>
        <ol>
        {
            for $constituent in $constituents
            let $label := $constituent/mods:titleInfo
            let $constituentID := $constituent/@ID
            return <li><a href="../constituents/{$bmtnid}/{$constituentID}">{$label}</a></li>
        }
        </ol>
    </section>
    </body>
</html>