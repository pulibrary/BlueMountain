xquery version "3.0";


declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace xlink="http://www.w3.org/1999/xlink";

let $byline := request:get-parameter("byline", "")
return $byline