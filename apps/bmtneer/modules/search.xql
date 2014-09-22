xquery version "3.0" encoding "UTF-8";

import module namespace kwic = "http://exist-db.org/xquery/kwic"
    at "resource:org/exist/xquery/lib/kwic.xql";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare option exist:serialize "method=html media-type=text/html indent=no";

declare variable $page-title as xs:string := "Search Demo Result";
declare variable $search-expression as xs:string := request:get-parameter("searchexpr", "");
declare variable $collection as xs:string := "/db/bluemtn/transcriptions";

<html>
    <head>
        <meta HTTP-EQUIV="Content-Type" content="text/html; charset=UTF-8"/>
		<title>{$page-title}</title>
        <style>
            span.hi {{ border: thin solid black; font-weight: bold;}}
            span.previous {{ font-style: italic; }}
            span.following {{ font-style: italic; }}			
        </style>
	</head>
    <body>
        <h1>{$page-title}</h1>
        <p>Search expression: <code>{$search-expression}</code></p>
        <h3>Results:</h3>
        {
            for $hit in collection($collection)//tei:ab[ft:query(., $search-expression)]
            let $score as xs:float := ft:score($hit)
            order by $score descending
            return
            (
                <p>Score: {$score}:</p>, 
                kwic:summarize($hit, <config width="40"/>)
            )			
		}
	</body>
</html>
