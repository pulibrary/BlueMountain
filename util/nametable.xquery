xquery version "3.0";

declare namespace mods="http://www.loc.gov/mods/v3";
<html>
<body>
<table>
<tr>
    <th>displayForm</th>
    <th>viafid</th>
    <th>title</th>
    <th>id</th>
    <th>issue</th>
</tr>
{
let $recs := collection('/db/bluemtn/metadata/periodicals/bmtnaau/issues')//mods:mods
for $rec in $recs
    let $recid := xs:string($rec/mods:recordInfo/mods:recordIdentifier)
    for $name in $rec//mods:name
    return
        <tr>
            <td>{ xs:string($name/mods:displayForm) }</td>
            <td></td>
            <td>{ xs:string($name/parent::mods:relatedItem/mods:titleInfo[1]/mods:title[1]) }</td>
            <td>{ xs:string($name/parent::mods:relatedItem/@ID) }</td>
            <td>{ $recid }</td>
        </tr>
} </table>
</body>
</html>