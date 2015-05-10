xquery version "1.0";

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

let $key := request:get-parameter('key', '')
let $name := collection('/db/apps/names/data')/name[key = $key]
return

    <html>
        <head>
            <title>Name {$name/appellation/text()}</title>
        </head>
        <body>
            <dl>
                <dt>Appellation</dt>
                <dd>{ $name/appellation/text() }</dd>
                
                <dt>Actor</dt>
                <dd>{ $name/actor/text() }</dd>
            </dl>
        </body>
    </html>