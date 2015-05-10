xquery version "1.0";

declare option exist:serialize "method=xhtml media-type=text/xml indent=yes process-xsl-pi=no";

let $new := request:get-parameter('new', '')
let $key := request:get-parameter('key', '')
let $data-collection := '/db/apps/names/data'

(: Put in the appropriate file name.  Use new-instance.xml for new forms and get the data
   from the data collection for updates.  :)
let $file := if ($new) then 
        'new-instance.xml'
    else 
        concat('../data/', $key, '.xml')

let $form := 
<html xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xf="http://www.w3.org/2002/xforms" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ev="http://www.w3.org/2001/xml-events" >
    <head>
       <title>Edit Item</title>
       <style type="text/css">
       <![CDATA[
       @namespace xf url("http://www.w3.org/2002/xforms");

       body {
           font-family: Helvetica, Ariel, Verdana, sans-serif;
       }

       .appellation .xforms-value {width: 50ex;}
       .actor .xforms-value {
           height: 5em;
           width: 600px;
       }
           
       /* align the labels but not the save label */
       xf|output xf|label, xf|input xf|label, xf|textarea xf|label, xf|select1 xf|label {
           display: inline-block;
           width: 14ex;
           text-align: right;
           vertical-align: top;
           margin-right: 1ex;
           font-weight: bold;
       }

       xf|input, xf|select1, xf|textarea, xf|ouptut {
           display: block;
           margin: 1ex;
       }
       ]]>
       </style>
       <xf:model>
           <xf:instance xmlns="" src="{$file}" id="save-data"/>
           <xf:submission id="save" method="post" action="{if ($new='true') then ('save-new.xq') else ('update.xq')}" instance="my-task" replace="all"/>
       </xf:model>
    </head>
    <body>
                <h1>Edit Name</h1>
                                
                {if ($key) then
                    <xf:output ref="key" class="key">
                        <xf:label>key:</xf:label>
                    </xf:output>
                else ()}
                <br/>
                <xf:input ref="appellation" class="appellation">
                    <xf:label>Appellation:</xf:label>
                </xf:input>     
                
                <xf:input ref="actor" class="actor">
                    <xf:label>Actor:</xf:label>
                </xf:input>
                
                
                
                <xf:submit submission="save">
                    <xf:label>Save</xf:label>
                </xf:submit>
    </body>
</html>
            
let $xslt-pi := processing-instruction xml-stylesheet {'type="text/xsl" href="/exist/rest/db/xforms/xsltforms/xsltforms.xsl"'}
            
return ($xslt-pi, $form)