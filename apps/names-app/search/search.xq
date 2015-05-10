xquery version "1.0";

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

let $data-collection := '/db/apps/names/data'
let $q := request:get-parameter('q', "")

(: put the search results into memory using the eXist any keyword ampersand equals comparison :)
let $search-results := collection($data-collection)/name[ft:query(*, $q)]
let $count := count($search-results)

return
<html>
    <head>
       <title>Name Search Results</title>
     </head>
     <body>
        <h3>Name Search Results</h3>
        <p><b>Search results for:</b>&quot;{$q}&quot; <b> In Collection: </b>{$data-collection}</p>
        <p><b>Terms Found: </b>{$count}</p>
     <ol>{
           for $item in $search-results
              let $key := $item/key
              let $label := $item/appellation/text()
              order by upper-case($label)
          return
            <li>
               <a href="../views/view-item.xq?id={$key}">{$label}</a>
            </li>
      }</ol>
      <a href="search-form.html">New Search</a>
      <a href="../index.html">App Home</a>
   </body>
</html>