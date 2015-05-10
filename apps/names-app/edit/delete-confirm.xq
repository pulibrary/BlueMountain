xquery version "1.0";

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

let $key := request:get-parameter("key", "")

let $data-collection := '/db/apps/names/data/'
let $doc := concat($data-collection, $key, '.xml')

return
<html>
    <head>
        <title>Delete Confirmation</title>
        <style>
        <![CDATA[
        .warn {background-color: silver; color: black; font-size: 16pt; line-height: 24pt; padding: 5pt; border: solid 2px black;}
        ]]>
        </style>
    </head>
    <body>
        <a href="../index.html">Item Home</a> &gt; <a href="../views/list-items.xq">List Items</a>
        <h1>Are you sure you want to delete this term?</h1>
        <strong>Name: </strong>{doc($doc)/name/appellation/text()}<br/>
        <strong>Path: </strong> {$doc}<br/>
        <br/>
        <a class="warn" href="delete.xq?key={$key}">Yes - Delete This Term</a>
        <br/>
        <br/>
        <a  class="warn" href="../views/view-item.xq?key={$key}">Cancel (Back to View Term)</a>
    </body>
</html>