<?xml version="1.0" encoding="utf-8"?>

<!-- Stylesheet for inserting viaf ids into Blue Mountain mets -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:mets="http://www.loc.gov/METS/"
		xmlns:mods="http://www.loc.gov/mods/v3"
		xmlns:local="http://diglib.princeton.edu"
		exclude-result-prefixes="xs mods" version="2.0">
  
  
  <xsl:variable name="viaftable" select="document('viaftable.xml')" />
  
  <xsl:output
      method="xml"
      encoding="UTF-8"
      indent="yes" />
  
  <xsl:function name="local:viafid-from-displayForm">
    <xsl:param name="name-string" as="xs:string?"/>
    <xsl:choose>
      <xsl:when test="$name-string">
        <xsl:value-of select="$viaftable//row[matches(displayForm, $name-string)][1]/viafid/text()" />
      </xsl:when>
    </xsl:choose>
  </xsl:function>
  
  <xsl:template match="mods:name-old">
    <xsl:variable name="display-string" select="mods:displayForm/text()" />
      <name>
        <source><xsl:value-of select="$display-string"></xsl:value-of></source>
        <id><xsl:value-of select="local:viafid-from-displayForm(mods:displayForm/text())" /></id>
      </name>  
  </xsl:template>
  
  <xsl:template match="mods:name">
    <xsl:variable name="display-string" select="mods:displayForm/text()" />
    <xsl:variable name="viafid" select="local:viafid-from-displayForm($display-string)"/>
    <mods:name>
      <xsl:attribute name="type" select="@type"/>
      <xsl:if test="$viafid">
        <xsl:attribute name="authority">viaf</xsl:attribute>
        <xsl:attribute name="valueURI" select="concat('http://viaf.org/viaf/', $viafid)"/>
      </xsl:if>
      <xsl:apply-templates />
    </mods:name>
    
  </xsl:template>
  
  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>
 
 <xsl:template match="/ld">
<result>
   
   <names>
   <xsl:apply-templates select="//mods:name" />
   </names>
</result>
 </xsl:template>
 
 <!--  Identity Transform --> 
  <xsl:template match="@*|*|processing-instruction()|comment()">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
