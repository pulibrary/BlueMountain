xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";
<html>
  <body>
  <table>

    {
      for $p in request:get-parameter-names()
      let $v := request:get-parameter($p,())
      order by $p
      return
      <tr>
	<td>{$p}</td>
	<td>{$v}</td>
      </tr>
    }
  </table>
  </body>
</html>
