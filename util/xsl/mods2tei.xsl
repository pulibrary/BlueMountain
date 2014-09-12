<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
 xmlns="http://www.tei-c.org/ns/1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:tei="http://www.tei-c.org/ns/1.0"
 xmlns:mods="http://www.loc.gov/mods/v3"
 xmlns:local="http://library.princeton.edu/cew" 
 exclude-result-prefixes="xs  local xlink" 
 version="2.0">
 
 <xsl:strip-space elements="*"/>
 <xsl:output indent="yes"/>


 <!-- MODS templates -->
 <xsl:template match="mods:mods">
   <biblStruct>
     <monogr>
       <title level="j">
	 <xsl:if test="mods:titleInfo/mods:nonSort">
	   <seg type="nonSort"><xsl:apply-templates select="mods:titleInfo/mods:nonSort"/></seg>
	 </xsl:if>
	 <seg type="main"><xsl:apply-templates select="mods:titleInfo/mods:title"/></seg>
       </title>
       <imprint>
	 <xsl:if test="mods:part/mods:detail[@type='volume']">
	   <biblScope type="vol">
	     <xsl:value-of select="mods:part/mods:detail[@type='volume']/mods:number"/>
	   </biblScope>
	 </xsl:if>
	 <xsl:if test="mods:part/mods:detail[@type='number']">
	   <biblScope type="issue">
	     <xsl:value-of select="mods:part/mods:detail[@type='number']/mods:number"/>
	   </biblScope>
	 </xsl:if>
	 <date>
	   <xsl:attribute name="when">
	     <xsl:value-of select="mods:originInfo/mods:dateIssued[@encoding='w3cdtf']"/>
	   </xsl:attribute>
	     <xsl:value-of select="mods:originInfo/mods:dateIssued[@keyDate = '']"/>
	 </date>
       </imprint>
     </monogr>
     <xsl:apply-templates select="mods:relatedItem[@type='constituent']" />
   </biblStruct>
 </xsl:template>

 <xsl:template match="mods:relatedItem[@type='constituent']">
   <relatedItem type="constituent" xml:id="{@ID}">
     <biblStruct>
       <analytic>
	 <xsl:apply-templates select="mods:titleInfo"/>
	 <xsl:apply-templates select="mods:name"/>
	 <xsl:apply-templates select="mods:language"/>
       </analytic>
       <monogr>
	 <imprint>
	   <biblScope type="pp" corresp="{mods:part/mods:extent[@unit='page']/mods:start}"/>
	 </imprint>
       </monogr>
       <xsl:apply-templates select="mods:note"/>
       <xsl:apply-templates select="mods:relatedItem[@type='constituent']" />
     </biblStruct>
   </relatedItem>
 </xsl:template>

 <xsl:template match="mods:titleInfo">
   <title level="a">
     <xsl:if test="mods:nonSort">
       <seg type="nonSort"><xsl:apply-templates select="mods:nonSort"/></seg>
     </xsl:if>
     <seg type="main"><xsl:apply-templates select="mods:title"/></seg>
   </title>
 </xsl:template>

 <xsl:template match="mods:name">
   <respStmt>
     <persName><xsl:value-of select="mods:displayForm"/></persName>
     <resp><xsl:value-of select="mods:role/mods:roleTerm"/></resp>
   </respStmt>
 </xsl:template>

 <xsl:template match="mods:language">
   <textLang mainLang="{mods:languageTerm}"/>
 </xsl:template>


</xsl:stylesheet>



