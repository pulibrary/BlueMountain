xquery version "1.0";

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

<html>
    <head>
        <title>List of Names</title>
    </head>
    <body>
        <h1>Names</h1>
        <ol>{
            for $name in collection('/db/apps/names/data')/name
            let $label := $name/appellation/text()
            let $key := $name/key/text()
            let $livalue := <a href="view-item.xq?key={$name/key/text()}">{ $label }</a>
            order by $label
            return
                <li>{ $livalue }</li>
        }</ol>
    
    </body>
</html>