<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
		xmlns:mets="http://www.loc.gov/METS/" xmlns:mods="http://www.loc.gov/mods/v3"
		xmlns="http://www.loc.gov/METS/" exclude-result-prefixes="#all" version="2.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> May 10, 2015</xd:p>
      <xd:p><xd:b>Author:</xd:b> cwulfman</xd:p>
      <xd:p/>
    </xd:desc>
  </xd:doc>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="mets:structMap[@TYPE='LOGICAL']//mets:div[not(empty(@DMDID))]">

    <xsl:variable name="newlabel">
      <xsl:value-of
	  select="ancestor::mets:mets//mods:relatedItem[@ID = current()/@DMDID]/mods:titleInfo[1]/mods:title[1]/text()"
	  />
    </xsl:variable>
    
    <xsl:copy>
      <xsl:apply-templates select="@ID|@TYPE|@DMDID|@ORDER|@ORDERLABEL"/>
      <xsl:attribute name="LABEL">
	<xsl:value-of select="$newlabel"/>
      </xsl:attribute>
      <xsl:apply-templates select="*"/>
    </xsl:copy>
    
  </xsl:template>

  <!--  Identity Transform -->
  <xsl:template match="@*|*|processing-instruction()|comment()">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
