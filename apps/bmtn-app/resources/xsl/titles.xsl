<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:bmtn-mods="http://bluemountain.princeton.edu/mods" xmlns:local="http://bluemountain.princeton.edu/xsl/titles" version="2.0" exclude-result-prefixes="xs xd mods">
    <xsl:import href="mods.xsl"/>
    <xsl:output method="html"/>
    <xsl:param name="app-root"/>
    <xsl:param name="veridianLink"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b> Nov 29, 2014</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:function name="local:title-icon">
        <xsl:param name="titleURN"/>
        <xsl:variable name="bmtnid" select="substring-after($titleURN, 'urn:PUL:bluemountain:')"/>
        <xsl:value-of select="concat('/exist/rest', $app-root, '/resources/icons/periodicals/', $bmtnid, '/large.jpg')"/>
    </xsl:function>
    <xsl:template match="mods:mods">
        <xsl:variable name="iconpath" select="local:title-icon(current()/mods:identifier[@type='bmtn'])"/>
        <xsl:variable name="linkpath" select="concat( 'title.html?titleURN=', current()/mods:identifier[@type='bmtn'])"/>
        <div class="col-sm-6 col-md-4">
            <div class="thumbnail">
                <img class="thumbnail" src="{$iconpath}" alt="icon"/>
                <div class="caption">
                    <dl class="dl-horizontal">
                        <dt>Title</dt>
                        <dd>
                            <xsl:apply-templates select="mods:use-title(., '')"/>
                        </dd>
                        <dt>Dates</dt>
                        <dd>
                            <xsl:value-of select="mods:display-date(.)"/>
                        </dd>
                        <dt>Place Published</dt>
                        <dd>
                            <xsl:choose>
                                <xsl:when test="mods:originInfo/mods:place/mods:placeTerm[@type='text' and @lang='en']">
                                    <xsl:apply-templates select="mods:originInfo/mods:place/mods:placeTerm[@type='text'  and @lang='en']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="mods:originInfo/mods:place/mods:placeTerm[@type='text'][1]"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </dd>
                    </dl>
                    <ul>
                        <li>
                            <a href="{$linkpath}">Overview</a>
                        </li>
                        <li>
                            <a href="{$veridianLink}">Read in archive</a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>