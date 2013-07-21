xquery version "1.0";
declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace xlink="http://www.w3.org/1999/xlink";

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; Charset=UTF-8"  /> 
</head>
<body><table border="1">
<thead>
 <tr>
  <th>title</th>
  <th>vnum</th>
  <th>vcap</th>
  <th>inum</th>
  <th>icap</th>
  <th>datestr</th>
  <th>keydate</th>
 </tr>
</thead>
{
for $rec in collection('/db/bluemtn/metadata/periodicals/bmtnabk/issues')//mods:mods
let $title := $rec/mods:titleInfo/mods:title/text(),
    $volnum := $rec/mods:part/mods:detail[@type='volume']/mods:number/text(),
    $volcap := $rec/mods:part/mods:detail[@type='volume']/mods:caption/text(),
    $issnum := $rec/mods:part/mods:detail[@type='number']/mods:number/text(),
    $isscap := $rec/mods:part/mods:detail[@type='number']/mods:caption/text(),
    $datstr := $rec/mods:originInfo/mods:dateIssued[empty(@encoding)]/text(),
    $datkey := $rec/mods:originInfo/mods:dateIssued[@encoding='w3cdtf']/text()

order by $rec/mods:originInfo/mods:dateIssued[@keyDate='yes']
return
    <tr>
        <td>{$title}</td>
        <td>{$volnum}</td>
        <td>{$volcap}</td>
        <td>{$issnum}</td>
        <td>{$isscap}</td>
        <td>{$datstr}</td>
        <td>{$datkey}</td>
    </tr>
}
</table></body></html>