xquery version "3.0";

declare namespace mods="http://www.loc.gov/mods/v3";

declare option exist:serialize "method=json media-type=text/javascript";



<result> {
    let $data-collection := '/db/bluemtn/metadata/periodicals/bmtnaap'
    for $doc in collection($data-collection)[ends-with(base-uri(.), '.mets.xml')]
    return 
        <item someattr = "foo">
            <url>{base-uri($doc)}</url>
            <title>{$doc//mods:mods/mods:titleInfo[1]/mods:title/text()}</title>
        </item>
}
</result>