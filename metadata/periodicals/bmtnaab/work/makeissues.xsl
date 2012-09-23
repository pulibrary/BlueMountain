<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mets="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:local="http://diglib.princeton.edu" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="bmtnid" as="xs:string">bmtnaab</xsl:variable>

    <xsl:function name="local:convertDate">
      <xsl:param name="dateString" as="xs:string"/>
      <xsl:if test="$dateString">
	<xsl:analyze-string select="$dateString" regex="(\d+)-?(\d+)?">
	  <xsl:matching-substring>
	    <xsl:choose>
	      <xsl:when test="string-length(regex-group(2)) &lt; 1">
		<xsl:value-of select="concat($dateString, '-00')"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="$dateString"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:matching-substring>
	  <xsl:non-matching-substring>
	    <xsl:message terminate="yes" select="concat($dateString, ' does not match.')"/>
	  </xsl:non-matching-substring>
	</xsl:analyze-string>
      </xsl:if>
    </xsl:function>

    <xsl:template match="mods:modsCollection">
      <xsl:apply-templates select="mods:mods/mods:relatedItem[@type='constituent']" mode="mods"/>
      <xsl:apply-templates select="mods:mods/mods:relatedItem[@type='constituent']" mode="mets"/>
    </xsl:template>

    <xsl:template match="mods:relatedItem[@type='constituent']" mode="mets">
      <xsl:variable name="basename">
        <xsl:value-of select="concat($bmtnid, '_', local:convertDate(mods:originInfo/mods:dateIssued),'-01')"/>
      </xsl:variable>
      
      <xsl:variable name="filename">
        <xsl:value-of
            select="concat('/tmp/', $bmtnid, '/issues/',$basename,'/',$basename,'.mets.xml' )"/>
      </xsl:variable>
      
      <xsl:result-document href="{$filename}">
        <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
              TYPE="METAe_Serial" OBJID="urn:PUL:bluemountain:{$basename}">
          <metsHdr>
            <agent ROLE="CREATOR" TYPE="ORGANIZATION">
              <name>Princeton University Library, Digital Initiatives</name>
            </agent>
          </metsHdr>
          <metsDocumentID TYPE="URN">
            <xsl:value-of select="concat('urn:PUL:bluemountain:td:',$basename)"/>
          </metsDocumentID>
          <dmdSec ID="dmd1">
            <mdRef LOCTYPE="URN" MDTYPE="MODS" MIMETYPE="application/mods+xml"
                   xlink:href="{concat('urn:PUL:bluemountain:dmd:',$basename)}"/>
          </dmdSec>
          <structMap TYPE="PHYSICAL">
            <div/>
          </structMap>
          <structMap TYPE="LOGICAL">
            <div/>
          </structMap>
        </mets>
	
      </xsl:result-document>
    </xsl:template>

    <xsl:template match="mods:relatedItem[@type='constituent']" mode="mods">

      <xsl:variable name="basename">
        <xsl:value-of select="concat($bmtnid, '_', local:convertDate(mods:originInfo/mods:dateIssued), '-01')"/>
      </xsl:variable>
      
      
      <xsl:variable name="filename">
        <xsl:value-of
            select="concat('/tmp/', $bmtnid, '/issues/',$basename,'/',$basename,'.mods.xml' )"
            />
      </xsl:variable>
      <xsl:result-document href="{$filename}">
        <mods xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink">
          <recordInfo>
            <recordIdentifier>
              <xsl:value-of select="concat('urn:PUL:bluemountain:dmd:', $basename)"/>
            </recordIdentifier>
          </recordInfo>
          <identifier type="bmtn">
            <xsl:value-of select="concat('urn:PUL:bluemountain:',$basename)"/>
          </identifier>
          <typeOfResource>text</typeOfResource>
          <genre>Periodicals-Issue</genre>
          <titleInfo>
            <title>Action</title>
          </titleInfo>
	  <xsl:copy-of select="mods:part" />
	  <xsl:copy-of select="mods:originInfo"/>
          <location>
            <physicalLocation>SAX</physicalLocation>
            <holdingSimple>
              <copyInformation>
                <form>unbound</form>
              </copyInformation>
            </holdingSimple>
          </location>
	  
          <relatedItem type="host" xlink:type="simple"
                       xlink:href="{concat('urn:PUL:bluemountain:', $bmtnid)}">
            <recordInfo>
              <recordIdentifier><xsl:value-of select="concat('urn:PUL:bluemountain:dmd:', $bmtnid)"/></recordIdentifier>
            </recordInfo>
          </relatedItem>
        </mods>
      </xsl:result-document>
  </xsl:template>
  
</xsl:stylesheet>
