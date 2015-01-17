<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:bmtn-mods="http://bluemountain.princeton.edu/mods" version="2.0" exclude-result-prefixes="xs xd mods">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b> Nov 29, 2014</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:function name="mods:use-title">
        <xsl:param name="modsrec"/>
        <xsl:param name="mode"/>
        <xsl:choose>
            <xsl:when test="$modsrec/mods:titleInfo[@usage='primary']">
                <xsl:choose>
                    <xsl:when test="$mode = 'full'">
                        <xsl:apply-templates select="$modsrec/mods:titleInfo[@usage='primary']" mode="full"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$modsrec/mods:titleInfo[@usage='primary']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$mode = 'full'">
                        <xsl:apply-templates select="$modsrec/mods:titleInfo[1]" mode="full"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$modsrec/mods:titleInfo[1]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="mods:display-date">
        <xsl:param name="modsRec"/>
        <xsl:choose>
            <xsl:when test="$modsRec/mods:originInfo/mods:dateIssued[empty(@point)]">
                <xsl:apply-templates select="$modsRec/mods:originInfo/mods:dateIssued[empty(@point)]"/>
            </xsl:when>
            <xsl:when test="$modsRec/mods:originInfo/mods:dateIssued[@point='start'] and                 $modsRec/mods:originInfo/mods:dateIssued[@point='end']">
                <xsl:value-of select="string-join(($modsRec/mods:originInfo/mods:dateIssued[@point='start'],                     $modsRec/mods:originInfo/mods:dateIssued[@point='end']                     ), '-')"/>
            </xsl:when>
            <xsl:when test="$modsRec/mods:originInfo/mods:dateIssued[@point='start']">
                <xsl:value-of select="concat($modsRec/mods:originInfo/mods:dateIssued[@point='start'], '-')"/>
            </xsl:when>
            <xsl:when test="$modsRec/mods:originInfo/mods:dateIssued[@point='end']">
                <xsl:value-of select="concat('-', $modsRec/mods:originInfo/mods:dateIssued[@point='end'])"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>unexpected condition</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:template match="mods:detail">
        <xsl:choose>
            <xsl:when test="mods:caption">
                <xsl:value-of select="mods:caption"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="mods:number"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="mods:part">
        <xsl:if test="mods:detail[@type='volume']">
            <xsl:apply-templates select="mods:detail[@type='volume']"/>
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="mods:detail[@type='number']">
            <xsl:apply-templates select="mods:detail[@type='number']"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="mods:titleInfo" mode="full">
        <xsl:if test="mods:nonSort">
            <xsl:value-of select="concat(mods:nonSort, ' ')"/>
        </xsl:if>
        <xsl:value-of select="mods:title/text()"/>
        <xsl:if test="mods:subTitle">
            <xsl:value-of select="concat(': ', mods:subTitle/text())"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="mods:titleInfo">
        <xsl:if test="mods:nonSort">
            <xsl:value-of select="concat(mods:nonSort, ' ')"/>
        </xsl:if>
        <xsl:value-of select="mods:title/text()"/>
    </xsl:template>
    <xsl:template match="mods:originInfo">
        <xsl:value-of select="mods:dateIssued[empty(@keyDate)]"/>
    </xsl:template>
    <xsl:template match="mods:relatedItem" mode="list">
        <div class="constituent">
            <span class="title">
                <xsl:choose>
                    <xsl:when test="mods:titleInfo">
                        <xsl:apply-templates select="mods:titleInfo"/>
                    </xsl:when>
                    <xsl:otherwise>[untitled]</xsl:otherwise>
                </xsl:choose>
            </span>
            <br/>
            <span class="creator">
                <xsl:value-of select="mods:name/mods:displayForm" separator=", "/>
            </span>
        </div>
    </xsl:template>
</xsl:stylesheet>