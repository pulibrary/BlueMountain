<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="/">
        <xsl:text>[['Issue', 'Pages'],</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template match="issue">
        <xsl:variable name="apos">'</xsl:variable>
        <xsl:variable name="date" select="./date"/>
        <xsl:value-of select="concat('[', $apos, $date, $apos, ',',  ./pagecount, '],')"/>
    </xsl:template>
</xsl:stylesheet>