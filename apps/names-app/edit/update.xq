xquery version "1.0";

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";
 
let $title := 'Update Confirmation'
let $data-collection := '/db/apps/names/data'
 
(: get the form data that has been "POSTed" to this XQuery :)
let $item := request:get-data()
 
(: log into the collection :)
let $login := xmldb:login($data-collection, 'admin', 'admin')

(: get the id out of the posted document :)
let $key := $item/name/key/text() 

let $file := concat($key, '.xml') 
 
(: save the new file, overwriting the old one :)
let $store := xmldb:store($data-collection, $file, $item)

return
<html>
    <head>
       <title>{$title}</title>
    </head>
    <body>
    <h1>{$title}</h1>
    <p>Item {$key} has been updated.</p>
    </body>
</html>