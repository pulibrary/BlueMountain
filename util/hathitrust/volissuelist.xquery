declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace xlink="http://www.w3.org/xlink";

<html>
<head>
	<meta charset="utf-8"/>
</head>
 <body>
 {
  <table>
  <tr><th>title</th><th>volume no.</th><th>issue no.</th><th>date</th><th>issue id</th></tr>
  {
  let $hosts := collection('/db/bluemtn/metadata/periodicals')//mods:mods[mods:genre = 'Periodicals-Title']
for $host in $hosts
let $hostrecid := $host/mods:recordInfo/mods:recordIdentifier[@source='bmtn']
let $hostrectitle := xs:string($host/mods:titleInfo[1]/mods:title)
let $issues := collection('/db/bluemtn/metadata/periodicals')//mods:mods[mods:relatedItem[@type='host']/mods:recordInfo/mods:recordIdentifier = $hostrecid]

  	for $issue in $issues
     	let $id := $issue/mods:identifier[@type='bmtn']
  	let $volume := xs:string($issue/mods:part[@type='issue']/mods:detail[@type='volume']/mods:number)
  	let $number := 
  		for $number in $issue/mods:part[@type='issue']/mods:detail[@type='number']/mods:number
  		return xs:string($number)
  	
  	let $date   := xs:string($issue/mods:originInfo/mods:dateIssued[@keyDate='yes'][1])
  	order by $id
  	return
  		<tr>
  			<td>{ $hostrectitle }</td>
  			<td>{ $volume }</td>
  			<td>{ $number }</td>
  			<td>{ $date   }</td>
  			<td>{ xs:string($id) }</td>
  		</tr>
  }
  </table>
  
  }
 </body>
</html>
	