xquery version "3.0";

module namespace app="http://bluemountain.princeton.edu/modules/app";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://bluemountain.princeton.edu/config" at "config.xqm";

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";




(:~
 : Returns a valid xs:date from a w3cdtf-formatted string.
 : The input string may simply be a year (e.g., '2015'), in which
 : case the function appends January 1 to it (e.g., 2015-01-01);
 : if it is a YearMonth, then the function returns default first of 
 : the month.
 :
 : The function works by seeing if it can cast the input string as
 : an xs:date type.
 : @param $d a string in w3cdtf format
 :)
declare function app:w3cdtf-to-xsdate($d as xs:string) as xs:date
{
  let $dstring :=
  if ($d castable as xs:gYear) then $d || "-01-01"
  else if ($d castable as xs:gYearMonth) then $d || "-01"
  else if ($d castable as xs:date) then $d
  else error($d, "not valid w3cdtf")
  return xs:date($dstring)
};

(:~
 : Given the id of a magazine issue (e.g., bmtnaap_1921-11_01),
 : return the URL to the issue in the Blue Mountain Veridian instance.
 : 
 : Veridian has an unusual internal syntax for its urls; this function
 : defines sections of the URL and concatenates them together.
 : @param $bmtnid The id of an issue (e.g., bmtnaap_1921-11_01)
 :)
declare function app:veridian-url-from-bmtnid($bmtnid as xs:string)
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

(:~
 : Given a title id (e.g., bmtnaap), return a URL to the title in Veridian.
 :
 : Much like app:veridian-url-from-bmtnid(), but the syntax differs.
 : (Possible code refactoring here.)
 :)
declare function app:veridian-title-url-from-bmtnid($bmtnid as xs:string)
as xs:string
{
    let $protocol    := "http://",
        $host        := "bluemountain.princeton.edu",
        $servicePath := "bluemtn",
        $scriptPath  := "cgi-bin/bluemtn",
        $a           := "cl",
        $cl          := "CL1",
        $e           := "-------en-20--1--txt-txIN-------"
    
     let $idtok       := tokenize($bmtnid, ':')[last()]
    
     let $args        := '?a=' || $a || '&amp;cl=' || $cl || '&amp;sp=' || $idtok || '&amp;e=' || $e

    return $protocol || $host || '/' || $servicePath || '/' || $scriptPath || $args
}; 

(:~
 : Returns the title to use in the interface.  If there is a
 : titleInfo element marked as "primary", the use that; otherwise,
 : use the first titleInfo element in the record.
 :)
declare function app:use-title($modsrec as element())
as element()
{
    if ($modsrec/mods:titleInfo[@usage='primary'])
    then $modsrec/mods:titleInfo[@usage='primary']
    else $modsrec/mods:titleInfo[1]
};