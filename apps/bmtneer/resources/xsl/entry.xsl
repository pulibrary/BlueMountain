<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://bmtnfoo" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mets="http://www.loc.gov/mets" version="2.0" exclude-result-prefixes="xs mods mets">
    <xsl:output method="html"/>
    <xsl:param name="context"/>
    <xsl:function name="local:urn-to-bmtnid">
        <xsl:param name="urn"/>
        <xsl:value-of select="substring-after($urn, 'urn:PUL:bluemountain:')"/>
    </xsl:function>
    <xsl:function name="local:title-icon">
        <xsl:param name="titleURN"/>
        <xsl:variable name="bmtnid" select="substring-after($titleURN, 'urn:PUL:bluemountain:')"/>
        <xsl:value-of select="concat('http://localhost:8080/exist/rest/db/bluemtn/resources/icons/periodicals/', $bmtnid, '/large.jpg')"/>
    </xsl:function>
    <xsl:template name="title-string">
        <xsl:param name="modsrec"/>
        <span class="titleInfo">
            <xsl:apply-templates select="$modsrec/mods:titleInfo[not(@type='uniform')][1]"/>
        </span>
    </xsl:template>
    <xsl:template name="issue-label-string">
        <xsl:param name="modsrec"/>
        <span class="issueLabel">
            <xsl:apply-templates select="$modsrec/mods:part"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="$modsrec/mods:originInfo"/>
        </span>
    </xsl:template>
    <xsl:template name="title-thumbnail">
        <xsl:param name="modsrec"/>
        <xsl:variable name="iconpath" select="local:title-icon($modsrec/mods:identifier)"/>
        <xsl:variable name="linkpath" select="concat('http://localhost:8080/exist/apps/bmtneer/title.html?titleURN=', $modsrec/mods:identifier)"/>
        <div class="col-sm-6 col-md-3">
            <div class="thumbnail">
                <img class="thumbnail" src="{$iconpath}" alt="icon"/>
                <div class="caption">
                    <p>
                        <a href="{$linkpath}">
                            <span class="titleInfo">
                                <xsl:apply-templates select="$modsrec/mods:titleInfo[empty(@type)]"/>
                            </span>
                        </a>
                    </p>
                    <p>Lorem ipsum</p>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="mods:relatedItem">
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
    <xsl:template match="mods:titleInfo">
        <xsl:if test="mods:nonSort">
            <xsl:value-of select="concat(mods:nonSort, ' ')"/>
        </xsl:if>
        <xsl:value-of select="mods:title/text()"/>
    </xsl:template>
    <xsl:template match="mods:mods">
        <xsl:choose>
            <xsl:when test="$context = 'title-listing'">
                <xsl:call-template name="title-thumbnail">
                    <xsl:with-param name="modsrec" select="current()"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$context = 'selected-title-label'">
                <xsl:call-template name="title-string">
                    <xsl:with-param name="modsrec" select="current()"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$context = 'selected-issue-label'">
                <xsl:call-template name="title-string">
                    <xsl:with-param name="modsrec" select="current()"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$context = 'issue-listing-label'">
                <xsl:call-template name="issue-label-string">
                    <xsl:with-param name="modsrec" select="current()"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <i>
                    <xsl:apply-templates select="mods:titleInfo[not(@type='uniform')]"/>
                </i>
                <xsl:text>, </xsl:text>
                <xsl:apply-templates select="mods:part[@type='issue']"/>
                <xsl:text> (</xsl:text>
                <xsl:apply-templates select="mods:originInfo"/>
                <xsl:text>)</xsl:text>
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
    <xsl:template match="mods:originInfo">
        <xsl:value-of select="mods:dateIssued[empty(@keyDate)]"/>
    </xsl:template>
</xsl:stylesheet>