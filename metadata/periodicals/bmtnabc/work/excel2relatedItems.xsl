<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:mods="http://www.loc.gov/mods/v3" exclude-result-prefixes="xs ss mods" version="2.0">

<xsl:output indent="yes"></xsl:output>

 <xsl:template match="/">
  <mods:Collection>
   <xsl:apply-templates select="ss:Workbook/ss:Worksheet/ss:Table/ss:Row"/>
  </mods:Collection>
 </xsl:template>
 
 <xsl:template match="ss:Row[1]">
  
 </xsl:template>

 <xsl:template match="ss:Row">
  <mods:relatedItem type="constituent">
   <mods:titleInfo lang="fre">
    <mods:nonSort>La</mods:nonSort>
    <mods:title>Chronique musicale</mods:title>
   </mods:titleInfo>
   <mods:part type="issue">
    <mods:detail type="volume">
     <mods:number><xsl:value-of select="ss:Cell[1]/ss:Data" /></mods:number>
    </mods:detail>
    <mods:detail type="issue">
     <mods:number><xsl:value-of select="ss:Cell[2]/ss:Data"/></mods:number>
    </mods:detail>
   </mods:part>
   <mods:originInfo>
    <mods:dateIssued><xsl:value-of select="ss:Cell[3]/ss:Data" /></mods:dateIssued>
    <mods:dateIssued keyDate="yes"><xsl:value-of select="ss:Cell[4]/ss:Data" /></mods:dateIssued>
   </mods:originInfo>
  </mods:relatedItem>
 </xsl:template>


</xsl:stylesheet>
