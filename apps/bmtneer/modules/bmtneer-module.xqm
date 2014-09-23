xquery version "3.0";

module namespace bmtneer="http://blaueberg.info/bmtneer";

import module namespace config="http://blaueberg.info/bmtneer/config" at "config.xqm";


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



declare function bmtneer:icon-path($bmtnURN as xs:string)
as xs:string
{
    let $bmtnid   := tokenize($bmtnURN, ':')[last()] (: e.g., bmtnaae_1920-03_01 :)
    let $iconpath := replace($bmtnid, '(bmtn[a-z]{3})_([^_]+)_([0-9]+)', '$1/issues/$2_$3') (: e.g., bmtnaae/issues/1920-03_01 :)
    let $iconpath := replace($iconpath, '-', '/')
    (:     "http://localhost:8080/exist/rest/db/bluemtn/resources/icons/periodicals/bmtnaab/issues/1921/05_01" :)
    return $config:icon-root || $iconpath
};

declare function bmtneer:format-element($element as element(), $context as xs:string)
{
    let $xslt-parameters :=
        <parameters>
            <param name="context" value="{$context}"/>
        </parameters>
     return transform:transform($element, config:format-stylesheet-doc(), $xslt-parameters)
};