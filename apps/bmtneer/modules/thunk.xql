xquery version "3.0";


import module namespace bmtneer="http://blaueberg.info/bmtneer" at "bmtneer-module.xqm";


 let $an-id := "urn:PUL:periodicals:bluemountain:bmtnaad_1922-04_01"
 return bmtneer:veridian-url-from-bmtnid($an-id)