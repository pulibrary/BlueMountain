xquery version "3.0";

module namespace bmtneer="http://blaueberg.info/bmtneer";

declare function bmtneer:veridian-url-from-bmtnid($bmtnid as xs:string)
as xs:string
{
    let $protocol    := "http://",
        $host        := "bluemountain.princeton.edu",
        $servicePath := "bluemtn",
        $scriptPath  := "cgi-bin/bluemtn",
        $a           := "d",
        $e           := "-------en-20--1--txt-IN-----"
        
    let $idtok       := tokenize($bmtnid, ':')[last()]
    
    let $vid         := replace($idtok, '-','')
    let $vid         := replace($vid, '(bmtn[a-z]{3})_([^_]+)_([0-9]+)', '$1$2-$3')
    
    let $args        := '?a=' || $a || '&amp;d=' || $vid || '&amp;e=' || $e

    return $protocol || $host || '/' || $servicePath || '/' || $scriptPath || $args
}; 
