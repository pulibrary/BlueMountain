xquery version "3.0";

import module namespace config="http://bluemountain.princeton.edu/springs/config" at "config.xqm";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Blue Mountain Titles</title>
    </head>
    <body>
        <h1>Blue Mountain Titles</h1>
    <ol> {
        for $rec in collection('/db/bluemtn')//mods:mods
        let $title-string := $rec/mods:titleInfo[empty(@type)]/mods:title/string(),
            $id := $rec/mods:identifier
        
        
        where empty($rec/mods:relatedItem[@type='host'])
        order by upper-case($rec/mods:titleInfo[empty(@type)]/mods:title/string())
        return <li><a href="titles/{substring-after($id, 'urn:PUL:bluemountain:')}">{$title-string}</a></li>
    } </ol>
    </body>
</html>