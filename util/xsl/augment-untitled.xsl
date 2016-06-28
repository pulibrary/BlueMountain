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
    
    <xsl:template match="mods:title[. = 'Untitled']">
        <xsl:variable name="genre" select="ancestor::mods:relatedItem[1]/mods:genre/text()" />
        <xsl:choose>
            <xsl:when test="($genre = 'Illustration')">
                <mods:title><xsl:text>Untitled Image</xsl:text></mods:title>
            </xsl:when>
            <xsl:when test="($genre = 'TextContent')">
                <mods:title><xsl:text>Untitled Text</xsl:text></mods:title>
            </xsl:when>
            <xsl:when test="($genre = 'Music')">
                <mods:title><xsl:text>Untitled Music</xsl:text></mods:title>
            </xsl:when>
            <xsl:otherwise>
                <mods:title>Untitled</mods:title>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--  Identity Transform --> 
    <xsl:template match="@*|*|processing-instruction()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>