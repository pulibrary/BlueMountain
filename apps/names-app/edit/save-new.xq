xquery version "1.0";

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";
 
let $app-collection := '/db/apps/names'
let $data-collection := '/db/apps/names/data'
 
(: get the form data that has been "POSTed" to this XQuery :)
let $item := request:get-data()
 
(: get the next ID from the next-id.xml file :)
let $next-key-file-path := concat($app-collection,'/edit/next-key.xml')
let $key := doc($next-key-file-path)/data/next-key/text() 
let $file := concat($key, '.xml')

(: logs into the collection :)
let $login := xmldb:login($app-collection, 'admin', 'admin')

(: create the new file with a still-empty id element :)
let $store := xmldb:store($data-collection, $file, $item)

(: add the correct KEY to the new document we just saved :)
let $update-key :=  update replace doc(concat($data-collection, '/', $file))/name/key with <key>{$key}</key>

(: update the next-id.xml file :)
let $new-next-key :=  update replace doc($next-key-file-path)/data/next-key/text() with ($key + 1)

(: we need to return the original ID number in our results, but $id has already been increased by 1 :)
let $original-key := ($key - 1)

return
<html>
    <head>
       <title>Save Conformation</title>
    </head>
    <body>
        <a href="../index.html">Names Home</a>
        <p>Name {$original-key} has been saved.</p>
        <a href="../views/list-items.xq">List all names</a> 
    </body>
</html>