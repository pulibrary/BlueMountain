xquery version "3.0" encoding "UTF-8";
(:~
 : This Query was written for the PUL cataloging department
 : to assist them in creating MARC records for Blue Mountain's
 : resources.  Run against an eXist database containing METS/MODS
 : records, it generates a set of html files, one per title, each
 : comprising a <table> with the following columns, drawn from the
 : issue-level MODS:
 : <ul>
 :  <li>Volume Number (if present)</li>
 :  <li>Volume Caption (if present)</li> 
 :  <li>Issue Number</li>
 :  <li>Issue Caption</li>
 :  <li>Date String (as it appears on the issue)</li>
 :  <li>Date Code (encoded in w3cdtf)</li>
 : </ul>
 : @author Cliff Wulfman
 : @version 1.0
 :)

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace xlink="http://www.w3.org/1999/xlink";

declare variable $collection  := "/db/bluemtn/metadata/periodicals";
declare variable $output-root := "/tmp/issue-lists/";

(:~
 : A utility function.
 : @param $bmtnid A bluemountain id of the form urn:PUL:bluemountain:bmtnXXX
 : @return A string representing the name of the title or "unknown" if it cannot
 : be determined.
 :)
declare function local:title-string-of($bmtnid as xs:string)
{
    let $modsrec := collection($collection)//mods:mods[./mods:identifier[@type='bmtn'] = $bmtnid]
    let $tstring :=
        if ($modsrec/mods:titleInfo)
        then xs:string($modsrec/mods:titleInfo[1])
        else "unknown"
    return $tstring
};

(:~
 : This function selects all the title-level MODS elements.
 : A title-level MODS is defined as having a mods:genre of "Periodicals-Title'.
 : @return A sequence of bmtnids, one for each periodical title in the database.
 :)
declare function local:title-bmtnids() as xs:string+
{
let $titleSequence :=
        for $rec in collection($collection)//mods:genre[.='Periodicals-Title']/ancestor::mods:mods
        order by upper-case($rec/mods:titleInfo[empty(@type)]/mods:title/string())
        return $rec
for $r in $titleSequence return xs:string($r/mods:identifier[@type='bmtn'])
};

(:~
 : For a given bmtnid, this function returns an unordered
 : sequence of all its issues.  An issue is considered to belong
 : to a title if its MODS record contains a <relatedItem @type='host'>
 : element whose @xlink:href attribute is equal to the title's bmtnid.
 : @param $titleid A string representing the bmtnid of the title.
 : @return A sequence of MODS elements.
 :)
declare function local:issues($titleid as xs:string) as element()*
{
    let $issues := collection($collection)//mods:relatedItem[@type='host'][@xlink:href = $titleid]
    return $issues/ancestor::mods:mods
};

(:~
 : The principal function in the query. It generates
 : an <html> element containing a table of issue data
 : that can be serialized to a file.
 : @param $titleid The bmtnid of a title
 : @return An <html> element
 :)
declare function local:title-data-html($titleid)
{
    <html>
    <head>
        <title>Issue list for {local:title-string-of($titleid)}</title>
    </head>
    <body>
    { local:title-data-table($titleid) }
    </body></html>
};

(:~
 : Function that returns an html <table> element
 : containing a header row and an ordered sequence of
 : issue-data-rows.  The rows are ordered by the w3cdtf-encoded
 : date of the issue, oldest to newest.
 : @param $titleid The bmtnid of the title
 : @return A <table> element.ß
 :)
declare function local:title-data-table($titleid)
{
    let $issues := local:issues($titleid)
    return
        <table>
            <tr>
                <th>volnum</th>
                <th>volcap</th>
                <th>issuenum</th>
                <th>issuecap</th>
                <th>datestring</th>
                <th>datecode</th>
            </tr>
        {
            for $issue in $issues
            order by $issue/mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf'][1]
            return local:issue-data-row($issue)
        }
        </table>
};

(:~
 : This function extracts the necessary metadata from an issue-level
 : mods element and returns it as an HTML table row.
 : @param $issue a <mods> element
 : @return a <tr> element containing <td> elements.
 :)
declare function local:issue-data-row($issue as element())
{
    let $volnum     := $issue/mods:part[@type='issue']/mods:detail[@type='volume']/mods:number/text()
    let $volcap     := $issue/mods:part[@type='issue']/mods:detail[@type='volume']/mods:caption/text()
    let $issuenum   := $issue/mods:part[@type='issue']/mods:detail[@type='number']/mods:number/text()
    let $issuecap   := $issue/mods:part[@type='issue']/mods:detail[@type='number']/mods:caption/text()
    let $datestring := $issue/mods:originInfo/mods:dateIssued[empty(@encoding)]/text()
    let $datecode   := $issue/mods:originInfo/mods:dateIssued[@encoding = 'w3cdtf']/text()
    return
        <tr>
            <td>{$volnum}</td>
            <td>{$volcap}</td>
            <td>{$issuenum}</td>
            <td>{$issuecap}</td>
            <td>{$datestring}</td>
            <td>{$datecode}</td>
        </tr>
};

declare function local:main()
{
for $tid in local:title-bmtnids()
let $bmtnid := tokenize($tid, ':')[last()]
order by $tid
return file:serialize(local:title-data-html($tid), 
                        $output-root || $bmtnid || ".html", 
                        ("indent=yes"))
};

local:main()

