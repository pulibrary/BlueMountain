xquery version "3.0";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace alto="http://www.loc.gov/standards/alto/ns-v2#";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace local="http://bluemountain.princeton.edu/springs/expressions";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xhtml";
declare option output:media-type "application/xhtml";

let $path-root := '/db/bluemtn/metadata/periodicals'

let $issues := collection($path-root)//mods:mods[mods:genre = 'Periodicals-Issue']
return 
        <body>
            <foo/>
    { count($issues) }
    </body>
