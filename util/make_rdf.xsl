<?xml version="1.0" encoding="utf-8"?>
<!-- 
     A set of templates for transforming Blue Mountain METS/MODS to
     RDF.  It borrows from the stylesheet I wrote for ModNets
     to transform MJP metadata into RDF for Collex.
 -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mets="http://www.loc.gov/METS/" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:role="http://www.loc.gov/loc.terms/relators/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs mods">

    <xsl:output indent="yes"/>

    <xsl:template match="mets:mets">
        <xsl:variable name="objid" select="@OBJID"/>
        <rdf:RDF>
            <xsl:apply-templates
                select="mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods">
                <xsl:with-param name="objid" select="@OBJID"/>
            </xsl:apply-templates>
        </rdf:RDF>
    </xsl:template>

    <xsl:template match="mods:mods">
        <xsl:param name="objid"/>
        <rdf:Description rdf:about="{$objid}">
            <dcterms:title>
                <xsl:apply-templates select="mods:titleInfo[1]"/>
            </dcterms:title>
            <dcterms:issued>
                <xsl:apply-templates select="mods:originInfo/mods:dateIssued[@keyDate='yes']"/>
            </dcterms:issued>
            <dcterms:isPartOf>
                <xsl:value-of select="mods:relatedItem[@type='host']/@xlink:href"/>
            </dcterms:isPartOf>
        </rdf:Description>
	
	<xsl:for-each select="mods:relatedItem[@type='constituent']">
	  <rdf:Description rdf:about="{$objid}#{@ID}">
	    <dcterms:title>
	      <xsl:apply-templates select="mods:titleInfo"/>
	    </dcterms:title>
	    <xsl:apply-templates select="mods:name" />

	    <dcterms:isPartOf>
	      <xsl:value-of select="$objid"/>
	    </dcterms:isPartOf>
	  </rdf:Description>
	</xsl:for-each>
    </xsl:template>

    <xsl:template match="mods:name">
      <xsl:variable name="ename" select="mods:role/mods:roleTerm/text()"/>
      <xsl:element name="{$ename}" namespace="http://id.loc.gov/vocabulary/relators/">
	<xsl:value-of select="mods:displayForm"/>
      </xsl:element>
    </xsl:template>

    <xsl:template match="mods:relatedItem[@type='constituent']">
      <dcterms:title>
	<xsl:apply-templates select="mods:titleInfo" />
      </dcterms:title>
    </xsl:template>


    <!-- This template converts a mods:titleInfo element into a formatted string.
    The complete format is the following: NonSort Title: Subtitle (Part) -->
    <xsl:template match="mods:titleInfo">
        <xsl:variable name="nonSort">
            <xsl:choose>
                <xsl:when test="mods:nonSort">
                    <xsl:value-of select="concat(mods:nonSort/text(), ' ')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="title">
            <xsl:value-of select="mods:title[1]/text()"/>
        </xsl:variable>
        <xsl:variable name="subTitle">
            <xsl:choose>
                <xsl:when test="mods:subTitle">
                    <xsl:value-of select="concat(': ', mods:subTitle[1]/text())"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="part">
            <xsl:choose>
                <xsl:when test="../mods:part[@type='issue']">
                    <xsl:variable name="volume">
                        <xsl:choose>
                            <xsl:when test="../mods:part/mods:detail[@type='volume']">
                                <xsl:value-of
                                    select="../mods:part/mods:detail[@type='volume']/mods:caption"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="number">
                        <xsl:choose>
                            <xsl:when test="../mods:part/mods:detail[@type='number']">
                                <xsl:value-of
                                    select="../mods:part/mods:detail[@type='number']/mods:caption"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:value-of select="concat(', ',$volume, ' ', $number)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($nonSort,$title,$subTitle, $part)"/>
    </xsl:template>


</xsl:stylesheet>
