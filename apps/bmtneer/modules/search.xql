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
        <table>
            <tr><th>score</th><th>magazine</th><th>date</th><th>hit</th></tr>
        {
            for $hit in collection($collection)//tei:ab[ft:query(., $search-expression)]
            let $score as xs:float := ft:score($hit)
            let $issueURN := $hit/ancestor::tei:TEI//tei:idno[ @type="bmtnid" ]
            let $constituentID := $hit/ancestor::tei:div/@corresp
            let $monogr := $hit/ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr
            let $title := $monogr/tei:title/tei:seg[@type='main']
            order by $score descending
            return
                <tr>
                    <td>{$score}</td>
                    <td><a href="constituent.html?issueURN={$issueURN}&amp;constituentID={$constituentID}">{$title}</a></td>
                    <td>{string($monogr/tei:imprint/tei:date/@when)}</td>
                    <td>{kwic:summarize($hit, <config width="40"/>)}</td>
                </tr>
 
		}
		</table>
	</body>
</html>
