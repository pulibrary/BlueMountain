<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:local="http://library.princeton.edu/cew" exclude-result-prefixes="xs local xlink tei mods"
  version="2.0">

  <xsl:strip-space elements="*"/>
  <xsl:output indent="yes"/>


  <!-- MODS templates -->
  <xsl:template match="mods:mods">
    <biblStruct>
      <monogr>
        <title level="j">
          <xsl:apply-templates select="mods:titleInfo"/>
        </title>
        <imprint>
          <xsl:if test="mods:part/mods:detail[@type='volume']">
            <biblScope unit="vol">
              <xsl:value-of select="mods:part/mods:detail[@type='volume']/mods:number"/>
            </biblScope>
          </xsl:if>
          <xsl:if test="mods:part/mods:detail[@type='number']">
            <biblScope unit="issue">
              <xsl:value-of select="mods:part/mods:detail[@type='number']/mods:number"/>
            </biblScope>
          </xsl:if>
          <date>
            <xsl:attribute name="when">
              <xsl:value-of select="mods:originInfo/mods:dateIssued[@encoding='w3cdtf']"/>
            </xsl:attribute>
            <xsl:value-of select="mods:originInfo/mods:dateIssued[@keyDate = '']"/>
          </date>
        </imprint>
      </monogr>
      <xsl:apply-templates select="mods:relatedItem[@type='host']"/>
      <xsl:apply-templates select="mods:relatedItem[@type='constituent']"/>
    </biblStruct>
  </xsl:template>

  <xsl:template match="mods:relatedItem[@type='host']">
    <relatedItem type="host" target="{@xlink:href}"/>
  </xsl:template>

  <xsl:template match="mods:relatedItem[@type='constituent']">
    <relatedItem type="constituent">
      <xsl:if test="@ID">
        <xsl:attribute name="xml:id" select="@ID"/>
      </xsl:if>
      <biblStruct>
        <analytic>
          <title level="a">
            <xsl:apply-templates select="mods:titleInfo"/>
          </title>
          <xsl:apply-templates select="mods:name"/>
          <xsl:apply-templates select="mods:language"/>
        </analytic>
        <monogr>
          <imprint>
            <classCode scheme="CCS">
              <xsl:value-of select="mods:genre[@type='CCS']"/>
            </classCode>
            <xsl:apply-templates select="mods:part/mods:extent"/>
            <!--<biblScope type="pp" corresp="{mods:part/mods:extent[@unit='page']/mods:start}"/>-->
          </imprint>
        </monogr>
        <xsl:apply-templates select="mods:note"/>
        <xsl:apply-templates select="mods:relatedItem[@type='constituent']"/>
      </biblStruct>
    </relatedItem>
  </xsl:template>

  <xsl:template
    match="mods:relatedItem[@type='constituent']/mods:part/mods:extent[@unit='page' and mods:list]">
    <xsl:variable name="pnums" select="tokenize(mods:list, '-')"/>
    <biblScope unit="page" from="{$pnums[1]}" to="{$pnums[2]}">
      <xsl:value-of select="mods:list"/>
    </biblScope>
  </xsl:template>

  <xsl:template
    match="mods:relatedItem[@type='constituent']/mods:part/mods:extent[@unit='page' and mods:start]">
    <biblScope unit="page">
      <xsl:value-of select="mods:start"/>
    </biblScope>
  </xsl:template>

  <xsl:template match="mods:titleInfo">
    
      <xsl:if test="mods:nonSort">
        <seg type="nonSort">
          <xsl:apply-templates select="mods:nonSort"/>
        </seg>
      </xsl:if>
      <seg type="main">
        <xsl:apply-templates select="mods:title"/>
      </seg>
      <xsl:if test="mods:subTitle">
        <seg type="sub">
          <xsl:apply-templates select="mods:subTitle"/>
        </seg>
      </xsl:if>
    
  </xsl:template>

  <xsl:template match="mods:name">
    <respStmt>
      <persName>
      	<xsl:if test="@valueURI">
      		<xsl:attribute name="ref">
      			<xsl:value-of select="@valueURI" />
      		</xsl:attribute>
      	</xsl:if>
        <xsl:value-of select="mods:displayForm"/>
      </persName>
      <resp>
        <xsl:value-of select="mods:role/mods:roleTerm"/>
      </resp>
    </respStmt>
  </xsl:template>

  <xsl:template match="mods:language">
    <textLang mainLang="{mods:languageTerm}"/>
  </xsl:template>


</xsl:stylesheet>
