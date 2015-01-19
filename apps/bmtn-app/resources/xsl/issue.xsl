<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:local="http://bluemountain.princeton.edu/xsl/titles" version="2.0" exclude-result-prefixes="xs xd mods">
    <xsl:import href="mods.xsl"/>
    <xsl:output method="html"/>
    <xsl:param name="context"/>
    <xsl:param name="veridianLink"/>
    <xsl:param name="titleURN"/>
    <xsl:param name="issueURN"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b> Nov 29, 2014</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="mods:mods">
        <span class="titleInfo">
            <xsl:apply-templates select="mods:titleInfo[empty(@type)]"/>
        </span>
    </xsl:template>
    <xsl:template match="mods:relatedItem">
        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="mods:titleInfo">
                    <xsl:apply-templates select="mods:titleInfo" mode="full"/>
                </xsl:when>
                <xsl:otherwise>[untitled]</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="creators">
            <xsl:value-of select="mods:name/mods:displayForm" separator=", "/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$context = 'constituent-listing-table'">
                <tr>
                    <td>
                        <xsl:value-of select="$title"/>
                    </td>
                    <td>
                        <xsl:value-of select="$creators"/>
                    </td>
<!--                    <td>
                        <a href="{$veridianLink}">view pages</a>
                    </td>
                    <td>
                        <a href="constituent.html?titleURN={$titleURN}&issueURN={$issueURN}&constituentID={@ID}">view text</a>
                    </td>-->
                </tr>
            </xsl:when>
            <xsl:when test="$context = 'selected-constituent-title'">
                <xsl:value-of select="$title"/>
            </xsl:when>
            <xsl:when test="$context = 'selected-constituent-creators'">
                <xsl:value-of select="$creators"/>
            </xsl:when>
            <xsl:otherwise>
                foo
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>