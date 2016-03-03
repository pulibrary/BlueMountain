<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mix="http://www.loc.gov/mix/"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:local="http://bluemountain/" exclude-result-prefixes="#all" version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>

    <xsl:key name="imageKey" match="mets:fileGrp[@ID = 'IMGGRP']/mets:file" use="@ID"/>
    <xsl:key name="techMD" match="mets:techMD" use="@ID" />

    <xsl:variable name="baseURI">http://bluemountain.princeton.edu/api/presentation</xsl:variable>
    <xsl:variable name="bmtnid">
        <xsl:value-of
            select="
                substring-after(
                /mets:mets/mets:dmdSec/mets:mdWrap[@MDTYPE = 'MODS']/mets:xmlData/mods:mods/mods:identifier[@type = 'bmtn'],
                'urn:PUL:bluemountain:')"
        />
    </xsl:variable>
    
    
    <xsl:function name="local:file-path">
        <xsl:param name="fileURI" />
        <xsl:variable name="protocol">http://</xsl:variable>
        <xsl:variable name="host">libimages.princeton.edu</xsl:variable>
        <xsl:variable name="service">loris2</xsl:variable>
        <xsl:variable name="base">bluemountain/astore%2Fperiodicals</xsl:variable>
        <xsl:variable name="path" select="substring-after($fileURI, 'file:///usr/share/BlueMountain/astore/periodicals/')" />
        <xsl:value-of select="concat($protocol, $host, '/', $service, '/', $base, '/', $path)"/>
    </xsl:function>
    
    

    <!-- A hack to get the image file associated with a div.
        Because there is no explicit attribute for it,
        Assume it is the area without a BEGIN attribute.
    -->
    

    <xsl:template name="metadata">
        <xsl:param name="metsrec" as="node()"/>
        <array key="metadata"> </array>
    </xsl:template>

    <xsl:template name="description">
        <xsl:param name="metsrec" as="node()"/>
        <string key="description">a description</string>
    </xsl:template>

    <xsl:template name="license">
        <xsl:param name="metsrec" as="node()">
            <string key="license">a license</string>
        </xsl:param>
    </xsl:template>

    <xsl:template name="attribution">
        <xsl:param name="metsrec" as="node()">
            <string key="attribution">an attributio</string>
        </xsl:param>
    </xsl:template>

    <xsl:template name="service-manifest">
        <xsl:param name="metsrec" as="node()">
            <map key="service"> </map>
        </xsl:param>
    </xsl:template>

    <xsl:template name="seeAlso">
        <xsl:param name="metsrec" as="node()">
            <map key="seeAlso"> </map>
        </xsl:param>
    </xsl:template>

    <xsl:template name="within">
        <xsl:param name="metsrec" as="node()">
            <string key="within">within URI</string>
        </xsl:param>
    </xsl:template>

    <xsl:template name="sequences">
        <xsl:param name="metsrec" as="node()"/>
        <array key="sequences">
            <xsl:call-template name="sequence-normal">
                <xsl:with-param name="metsrec" select="$metsrec"/>
            </xsl:call-template>
        </array>
    </xsl:template>

    <xsl:template name="sequence-normal">
        <xsl:param name="metsrec" as="node()"/>
        <map>
            <string key="@id">
                <xsl:value-of select="string-join(($baseURI, $bmtnid, 'sequence', 'normal'), '/')"/>
            </string>
            <string key="@type">sc:Sequence</string>
            <string key="label">Normal Page Order</string>
            <string key="viewingDirection">left-to-right</string>
            <string key="viewingHint">paged</string>

            <xsl:call-template name="canvases">
                <xsl:with-param name="metsrec" select="$metsrec"/>
            </xsl:call-template>
        </map>
    </xsl:template>

    <xsl:template name="structures">
        <xsl:param name="metsrec" as="node()"/>
        <array key="structures"> </array>
    </xsl:template>

    <xsl:template name="canvases">
        <xsl:param name="metsrec" as="node()"/>
        <array key="canvases">
            <xsl:apply-templates select="mets:structMap[@TYPE = 'PHYSICAL']"/>
        </array>
    </xsl:template>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="mets:structMap[@TYPE = 'PHYSICAL']">
        <xsl:apply-templates select="mets:div[@TYPE = 'Magazine']/mets:div"/>
    </xsl:template>

    <xsl:template match="mets:div">
        <xsl:variable name="image-fileid" select="mets:fptr//mets:area[not(@BEGIN)]/@FILEID" />
        <xsl:variable name="canvasid">
            <xsl:value-of select="string-join(($baseURI, $bmtnid, 'canvas', @ID), '/')"/>
        </xsl:variable>

        <map>
            <string key="@type">sc:Canvas</string>
            <string key="@id">
                <xsl:value-of select="$canvasid"/>
            </string>
            <string key="label">
                <xsl:choose>
                    <xsl:when test="@LABEL">
                        <xsl:value-of select="@LABEL"/>
                    </xsl:when>
                    <xsl:when test="@TYPE">
                        <xsl:value-of select="@TYPE"/>
                    </xsl:when>
                    <xsl:otherwise>Unlabeled</xsl:otherwise>
                </xsl:choose>
            </string>
            <array key="images">
            <xsl:apply-templates select="key('imageKey', $image-fileid)">
                <xsl:with-param name="canvasid" select="$canvasid" />
            </xsl:apply-templates>
            </array>
            
        </map>
    </xsl:template>

    <xsl:template match="mets:file">
        <xsl:param name="canvasid" />
        <map>
            <string key="@type">oa:Annotation</string>
            <string key="motivation">sc:painting</string>
            <map key="resource">
                <string key="@id">
                    <xsl:value-of select="local:file-path(mets:FLocat/@xlink:href)"/>
                </string>
                <string key="@type">dctypes:Image</string>
                <string key="format">
                    <xsl:value-of select="@MIMETYPE"/>
                </string>
                <map key="service">
                    <string key="@context">http://iiif.io/api/image/2/context.json</string>
                    <string key="@id">http://libimages.princeton.edu/loris2</string>
                    <string key="profile">http://iiif.io/api/image/2/level1.json</string>
                </map>
                
                <number key="height">
                    <xsl:value-of select="key('techMD', xs:string(@ADMID))//mix:ImageLength"/>
                </number>
                <number key="width">
                    <xsl:value-of select="key('techMD', xs:string(@ADMID))//mix:ImageWidth"/>
                </number>
            </map>
            <string key="on"><xsl:value-of select="$canvasid"/></string>
        </map>
        
    </xsl:template>

    <xsl:template match="mets:mets">
        <map>
            <string key="@context">http://iiif.io/api/presentation/2/context.json</string>
            <string key="@type">sc:Manifest</string>
            <string key="@id">
                <xsl:value-of select="string-join(($baseURI, $bmtnid, 'manifest'), '/')"/>
            </string>
            <string key="label">
                <xsl:value-of select="$bmtnid"/>
            </string>

            <xsl:call-template name="metadata">
                <xsl:with-param name="metsrec" select="current()"/>
            </xsl:call-template>

            <xsl:call-template name="description">
                <xsl:with-param name="metsrec" select="current()"/>
            </xsl:call-template>

            <xsl:call-template name="license">
                <xsl:with-param name="metsrec" select="current()"/>
            </xsl:call-template>

            <xsl:call-template name="attribution">
                <xsl:with-param name="metsrec" select="current()"/>
            </xsl:call-template>

            <xsl:call-template name="service-manifest">
                <xsl:with-param name="metsrec" select="current()"/>
            </xsl:call-template>

            <xsl:call-template name="seeAlso">
                <xsl:with-param name="metsrec" select="current()"/>
            </xsl:call-template>

            <xsl:call-template name="within">
                <xsl:with-param name="metsrec" select="current()"/>
            </xsl:call-template>


            <xsl:call-template name="sequences">
                <xsl:with-param name="metsrec" select="current()"/>
            </xsl:call-template>

            <xsl:call-template name="structures">
                <xsl:with-param name="metsrec" select="current()"/>
            </xsl:call-template>
        </map>
    </xsl:template>



</xsl:stylesheet>
