<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
 xmlns="http://www.tei-c.org/ns/1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:alto="http://www.loc.gov/standards/alto/ns-v2#" 
 xmlns:tei="http://www.tei-c.org/ns/1.0"
 xmlns:mets="http://www.loc.gov/METS/" 
 xmlns:mods="http://www.loc.gov/mods/v3"
 xmlns:local="http://library.princeton.edu/cew" 
 exclude-result-prefixes="xs alto tei mods mets local xlink" 
 version="2.0">
 
 <xsl:strip-space elements="*"/>
 <xsl:output indent="yes"/>


 <xsl:key name="files" match="mets:file" use="@ID"/>

 <!-- <alto:MeasurementUnit> is usually 1/10 millimeter (mm10). -->
 <xsl:function name="local:to-millimeter">
  <xsl:param name="value" as="xs:integer"/>
  <xsl:value-of select="$value * 10"/>
 </xsl:function>
 

 
 <xsl:template match="alto:Page" mode="physical logical">
  <pb>
   <xsl:attribute name="facs" select="@ID"/>
  </pb>
  <xsl:apply-templates mode="#current"/>
 </xsl:template>
 
 <xsl:template
  match="alto:TopMargin | alto:LeftMargin | alto:RightMargin | alto:BottomMargin | alto:PrintSpace" mode="physical logical">
  <xsl:apply-templates mode="#current"/>
 </xsl:template>
 
 <xsl:template match="alto:TextBlock" mode="physical logical">
  <ab>
   <xsl:attribute name="facs" select="@ID"/>
   <xsl:apply-templates mode="#current"/>
  </ab>
 </xsl:template>
 
 <xsl:template match="alto:TextLine" mode="physical logical">
  <lb>
   <xsl:attribute name="facs" select="@ID"/>
  </lb>
  <xsl:apply-templates mode="#current"/>
 </xsl:template>
 
 
 <xsl:template match="alto:String" mode="physical logical">
  <xsl:value-of select="@CONTENT"/>
  <xsl:text/>
 </xsl:template>
 
 <xsl:template match="alto:SP" mode="physical logical">
  <xsl:text> </xsl:text>
 </xsl:template>
 
 <xsl:template match="alto:HYP" mode="physical logical">
  <pc type="endhypen" pre="false">-</pc>
 </xsl:template>
 


<!-- Facsimile templates -->
 
 <!-- <alto:Page> corresponds with <tei:surface> -->
 <xsl:template match="alto:Page" mode="facsimile">
  <xsl:param name="imagepath" tunnel="yes"></xsl:param>
  <tei:surface type="page" xml:id="{@ID}" ulx="0" uly="0" lrx="{local:to-millimeter(@WIDTH)}" lry="{local:to-millimeter(@HEIGHT)}">
   <!--<xsl:attribute name="xml:id" select="@ID"/>-->
   <!--<xsl:attribute name="ulx">0</xsl:attribute>
   <xsl:attribute name="uly">0</xsl:attribute>
   <xsl:attribute name="lrx" select="local:to-millimeter(@WIDTH)"/>
   <xsl:attribute name="lry" select="local:to-millimeter(@HEIGHT)"/>-->
   
   <tei:graphic>
    <xsl:attribute name="url">
     <xsl:value-of
      select="$imagepath"/>
    </xsl:attribute>
   </tei:graphic>
   <xsl:apply-templates mode="#current"/>
  </tei:surface>
 </xsl:template>
 
 <xsl:template
  match="alto:TopMargin | alto:LeftMargin | alto:RightMargin | alto:BottomMargin | alto:PrintSpace"
  mode="facsimile">
  <tei:zone type="margin">
   <xsl:attribute name="xml:id" select="@ID"/>
   <xsl:attribute name="ulx" select="local:to-millimeter(xs:integer(@HPOS))"/>
   <xsl:attribute name="uly" select="local:to-millimeter(xs:integer(@VPOS))"/>
   <xsl:attribute name="lrx"
    select="local:to-millimeter(xs:integer(@HPOS)) + local:to-millimeter(xs:integer(@WIDTH))"/>
   <xsl:attribute name="lry"
    select="local:to-millimeter(xs:integer(@VPOS)) + local:to-millimeter(xs:integer(@HEIGHT))"/>
   
   <xsl:apply-templates mode="#current"/>
  </tei:zone>
 </xsl:template>
 
 <xsl:template match="alto:TextBlock" mode="facsimile">
  <tei:zone type="TextBlock">
   <xsl:attribute name="xml:id" select="@ID"/>
   <xsl:attribute name="ulx" select="local:to-millimeter(xs:integer(@HPOS))"/>
   <xsl:attribute name="uly" select="local:to-millimeter(xs:integer(@VPOS))"/>
   <xsl:attribute name="lrx"
    select="local:to-millimeter(xs:integer(@HPOS)) + local:to-millimeter(xs:integer(@WIDTH))"/>
   <xsl:attribute name="lry"
    select="local:to-millimeter(xs:integer(@VPOS)) + local:to-millimeter(xs:integer(@HEIGHT))"/>
   
   <xsl:apply-templates mode="#current"/>
  </tei:zone>
 </xsl:template>
 
 <xsl:template match="alto:TextLine" mode="facsimile">
  <tei:zone type="TextLine">
   <xsl:attribute name="xml:id" select="@ID"/>
   <xsl:attribute name="ulx" select="local:to-millimeter(xs:integer(@HPOS))"/>
   <xsl:attribute name="uly" select="local:to-millimeter(xs:integer(@VPOS))"/>
   <xsl:attribute name="lrx"
    select="local:to-millimeter(xs:integer(@HPOS)) + local:to-millimeter(xs:integer(@WIDTH))"/>
   <xsl:attribute name="lry"
    select="local:to-millimeter(xs:integer(@VPOS)) + local:to-millimeter(xs:integer(@HEIGHT))"/>
   
   <xsl:apply-templates mode="#current"/>
  </tei:zone>
 </xsl:template>
 
 <xsl:template match="alto:String" mode="facsimile">
  <tei:zone type="String">
   <xsl:attribute name="xml:id" select="@ID"/>
   <xsl:attribute name="ulx" select="local:to-millimeter(xs:integer(@HPOS))"/>
   <xsl:attribute name="uly" select="local:to-millimeter(xs:integer(@VPOS))"/>
   <xsl:attribute name="lrx"
    select="local:to-millimeter(xs:integer(@HPOS)) + local:to-millimeter(xs:integer(@WIDTH))"/>
   <xsl:attribute name="lry"
    select="local:to-millimeter(xs:integer(@VPOS)) + local:to-millimeter(xs:integer(@HEIGHT))"/>
   
   <xsl:value-of select="@CONTENT"/>
   
  </tei:zone>
  
 </xsl:template>
 
 <xsl:template match="alto:SP" mode="facsimile">
  <xsl:text> </xsl:text>
 </xsl:template>
 
 <xsl:template match="alto:HYP" mode="facsimile">
  <tei:pc type="endhypen" pre="false">-</tei:pc>
 </xsl:template>
 

</xsl:stylesheet>



