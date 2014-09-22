<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs xd tei" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 13, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>

    <xsl:output doctype-system="about:legacy-compat"/>
    
    <xd:doc scope="component">
        <xd:desc>Optional id of a constituent in the document. If
        it is set, transformation is limited to that constituent; otherwise
        the entire document is transformed.</xd:desc>
    </xd:doc>
    <xsl:param name="constituentID"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>stuff</title>
            </head>
            <body>
                <xsl:choose>
                    <xsl:when test="$constituentID">
                        <xsl:apply-templates select="//tei:div[@corresp = $constituentID]"></xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <header>
                            <xsl:apply-templates select="tei:TEI/tei:teiHeader"/>
                        </header>
                        <xsl:apply-templates select="tei:TEI/tei:text/tei:body"/>

                    </xsl:otherwise>
                </xsl:choose>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:body">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:div[@type='Magazine']">
        <xsl:text>the magazine</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:div[@type='PublicationInfo']">
        <section id="PublicationInfo">
            <p>The pubInfo section</p>
        </section>
    </xsl:template>

    <xsl:template match="tei:div[@type='EditorialContent']">
        <section id="EditorialContent">
            <p>The EditorialContent section</p>
            <xsl:apply-templates/>
        </section>
    </xsl:template>

    <xsl:template match="tei:div[@type='TextContent']">
        <article>
            <header>
                <xsl:apply-templates select="tei:div[@type='Head']"/>
                <xsl:apply-templates select="tei:div[@type='Byline']"/>
            </header>
            <xsl:apply-templates select="tei:div[@type='Copy']"/>
        </article>
    </xsl:template>

    <xsl:template match="tei:div[@type='Head']">
        <h1>
            <xsl:apply-templates/>
        </h1>
    </xsl:template>

    <xsl:template match="tei:div[@type='Byline']">
        <div class="Byline">
            <xsl:apply-templates/>
        </div>
    </xsl:template>



    <xsl:template match="tei:teiHeader">
        <xsl:apply-templates select="tei:fileDesc/tei:sourceDesc/tei:biblStruct"/>
    </xsl:template>

    <xsl:template match="tei:sourceDesc/biblStruct">
        <ol>
            <xsl:apply-templates select="tei:relatedItem[@type='constituent']"/>
        </ol>
    </xsl:template>

    <xsl:template match="tei:relatedItem[@type='constituent']">
        <li>
            <xsl:value-of select="tei:biblStruct/tei:analytic/tei:title"/>
        </li>
    </xsl:template>

    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>

    <xsl:template match="tei:ab">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>


</xsl:stylesheet>
