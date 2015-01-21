xquery version "3.0";

declare namespace mods="http://www.loc.gov/mods/v3";

let $bmtnid := request:get-parameter("bmtnid", ())
let $data-root := request:get-parameter("data-root", ())
return <dl>
    <dt>bmtnid</dt><dd>{$bmtnid}</dd>
    <dt>data-root</dt><dd>{$data-root}</dd>
</dl>
