<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:mods="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="#all"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 10, 2015</xd:p>
            <xd:p><xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="mods:title[contains(., 'Untitled') and ./ancestor::mods:relatedItem/mods:name]">
        <xsl:variable name="byline">
            <xsl:value-of select="./ancestor::mods:relatedItem[1]/mods:name[1]/mods:displayForm"/>
        </xsl:variable>
        <xsl:variable name="current-title">
            <xsl:value-of select="."/>
        </xsl:variable>
        <mods:title><xsl:value-of select="concat($current-title, ' by ', $byline)"/></mods:title>
    </xsl:template>
    
    <!--  Identity Transform --> 
    <xsl:template match="@*|*|processing-instruction()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>