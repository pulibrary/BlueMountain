<?xml version="1.0" encoding="UTF-8"?>
<!-- This stylesheet differs from others in this series; it must handle multiple issuance numbers 
     for issues that do not have month or day of publication.  For these situations, we must
     assume the mods encoder has included a bmtnid, which we simply copy. -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mets="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:local="http://diglib.princeton.edu" version="2.0" exclude-result-prefixes="#all">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="bmtnid" as="xs:string">bmtnabc</xsl:variable>
    <xsl:variable name="pathroot" as="xs:string">/tmp</xsl:variable>

    <xsl:function name="local:issueID">
      <xsl:param name="bmtnID" as="xs:string"/>
      <xsl:param name="keyDate" as="xs:string" />
      <xsl:param name="issueString" as="xs:string"/>

      <xsl:value-of select="concat($bmtnID, '_', $keyDate, '_', format-number(xs:integer($issueString), '00'))"/>
    </xsl:function>

    <xsl:function name="local:pathname">
      <xsl:param name="bmtnID" as="xs:string"/>
      <xsl:param name="keyDate" as="xs:string" />
      <xsl:param name="issueString" as="xs:string"/>

      <xsl:value-of select="concat(
			    $pathroot,
			    '/',
			    $bmtnID,
			    '/issues/',
			    replace($keyDate, '-', '/'),
			    '_',
			    format-number(xs:integer($issueString), '00')
			    )"/>
    </xsl:function>


    <xsl:template match="mods:mods">
      <xsl:apply-templates select="mods:relatedItem[@type='constituent']" mode="mods"/>
      <xsl:apply-templates select="mods:relatedItem[@type='constituent']" mode="mets"/>
    </xsl:template>

    <xsl:template match="mods:relatedItem[@type='constituent']" mode="mets">
      <xsl:variable name="keyDateString" select="mods:originInfo/mods:dateIssued[@keyDate='yes']" />
      <xsl:variable name="givenid" select="mods:identifier[@type='bmtn']" />   
      <xsl:variable name="basename">
	<xsl:choose>
	  <xsl:when test="$givenid">
	    <xsl:value-of select="substring-after($givenid, 'urn:PUL:bluemountain:')"/>
	  </xsl:when>
	 <xsl:otherwise>
           <xsl:value-of select="local:issueID($bmtnid, $keyDateString, '01')"/>
	 </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>

      <xsl:variable name="issueString">
	<xsl:choose>
	  <xsl:when test="$givenid">
	    <xsl:value-of select="tokenize(substring-after($givenid, 'urn:PUL:bluemountain:'), '_')[3]"/>
	  </xsl:when>
	  <xsl:otherwise><xsl:text>01</xsl:text></xsl:otherwise>
	</xsl:choose>
      </xsl:variable>

      <xsl:variable name="filename" select="concat($basename, '.mets.xml')" as="xs:string" />
      
      <xsl:variable name="filepath" select="concat(local:pathname($bmtnid, $keyDateString, $issueString), '/', $filename)" as="xs:string"/>
      
      <xsl:result-document href="{$filepath}">
        <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
              TYPE="Periodical-Issue" OBJID="urn:PUL:bluemountain:{$basename}">
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
      <xsl:variable name="keyDateString" select="mods:originInfo/mods:dateIssued[@keyDate='yes']" />   
      <xsl:variable name="givenid" select="mods:identifier[@type='bmtn']" />   
      <xsl:variable name="basename">
	<xsl:choose>
	  <xsl:when test="$givenid">
	    <xsl:value-of select="substring-after($givenid, 'urn:PUL:bluemountain:')"/>
	  </xsl:when>
	 <xsl:otherwise>
           <xsl:value-of select="local:issueID($bmtnid, $keyDateString, '01')"/>
	 </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>

      <xsl:variable name="issueString">
	<xsl:choose>
	  <xsl:when test="$givenid">
	    <xsl:value-of select="tokenize(substring-after($givenid, 'urn:PUL:bluemountain:'), '_')[3]"/>
	  </xsl:when>
	  <xsl:otherwise><xsl:text>01</xsl:text></xsl:otherwise>
	</xsl:choose>
      </xsl:variable>

      <xsl:variable name="filename" select="concat($basename, '.mods.xml')" as="xs:string" />
      
      <xsl:variable name="filepath" select="concat(local:pathname($bmtnid, $keyDateString, $issueString), '/', $filename)" as="xs:string"/>

      <xsl:result-document href="{$filepath}" >
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
	  <xsl:copy-of select="mods:titleInfo" />
	  <xsl:copy-of select="mods:part" />
	  <xsl:copy-of select="mods:originInfo" />
	  <xsl:copy-of select="mods:note" />
          <relatedItem type="host" xlink:type="simple"
                       xlink:href="urn:PUL:bluemountain:{$bmtnid}">
            <recordInfo>
              <recordIdentifier><xsl:value-of select="concat('urn:PUL:bluemountain:dmd:', $bmtnid)"/></recordIdentifier>
            </recordInfo>
          </relatedItem>
        </mods>
      </xsl:result-document>
  </xsl:template>
  
</xsl:stylesheet>
