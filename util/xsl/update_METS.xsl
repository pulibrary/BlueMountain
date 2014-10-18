<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:mods="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="xs xd mets mods"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 12, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:key name="constituent" match="mods:relatedItem" use="@ID" />
    
    <xsl:template match="mets:div[not(empty(@DMDID))]">
        <xsl:variable name="label">
            <xsl:apply-templates select="key('constituent', @DMDID)" mode="label"/>
        </xsl:variable>
        <mets:div LABEL="{$label}">
            <xsl:copy-of select="@*[name()!='LABEL']" />
            <xsl:apply-templates />
        </mets:div>
    </xsl:template>
    
    <xsl:template match="mods:relatedItem" mode="label">
        <xsl:variable name="art">
            <xsl:choose>
                <xsl:when test="mods:titleInfo/mods:nonSort">
                    <xsl:value-of select="concat(string(mods:titleInfo/mods:nonSort), ' ')" />
                </xsl:when>
                <xsl:otherwise><xsl:text /></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="title">
            <xsl:value-of select="mods:titleInfo/mods:title" />
        </xsl:variable>
        <xsl:variable name="byline">
            <xsl:choose>
                <xsl:when test="count(mods:name) = 1">
                    <xsl:text> by </xsl:text>
                    <xsl:apply-templates select="mods:name" mode="label" />
                </xsl:when>
                <xsl:when test="count(mods:name) = 2">
		  <xsl:variable name="name1">
		    <xsl:apply-templates select="mods:name[1]" mode="label" />
		  </xsl:variable>
		  <xsl:variable name="name2">
		    <xsl:apply-templates select="mods:name[2]" mode="label" />
		  </xsl:variable>
		  
                    <xsl:text> by </xsl:text>
		    <xsl:value-of select="concat($name1, ' and ', $name2)"/>
                </xsl:when>
                <xsl:when test="count(mods:name) &gt; 2">
                    <xsl:text> by </xsl:text>
                    <xsl:for-each select="mods:name">
                        <xsl:apply-templates select="." mode="label" />
                        <xsl:if test="position() &lt; last()"><xsl:text>, </xsl:text></xsl:if>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($art, $title, $byline)" />
    </xsl:template>
    
    <xsl:template match="mods:name" mode="label">
        <xsl:value-of select="mods:displayForm" />
    </xsl:template>
    
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
