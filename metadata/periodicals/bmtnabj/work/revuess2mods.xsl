<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
		xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" exclude-result-prefixes="xs ss"
		xmlns:local="http://diglib.princeton.edu" version="2.0">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:variable name="bmtnid" as="xs:string">bmtnabj</xsl:variable>
  <xsl:variable name="pathroot" as="xs:string">/tmp</xsl:variable>

  <!-- Begin insertion of functions from makeissues.xsl -->

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



  <!-- End insertion of functions from makeissues.xsl -->


  <xsl:template match="ss:Workbook">
    <xsl:apply-templates select="ss:Worksheet" mode="mods"/>
    <xsl:apply-templates select="ss:Worksheet" mode="mets"/>
  </xsl:template>

  <xsl:template match="ss:Worksheet" mode="mets">
    <xsl:apply-templates select="ss:Table/ss:Row" mode="#current"/>
  </xsl:template>

  <xsl:template match="ss:Worksheet" mode="mods">
    <xsl:variable name="ssname" select="@ss:Name" as="xs:string"/>

    <xsl:choose>
      <xsl:when test="$bmtnid">
        <xsl:apply-templates select="ss:Table/ss:Row" mode="#current">
          <xsl:with-param name="bmtnid" select="$bmtnid"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">no journal for this worksheet</xsl:message>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="ss:Row[position() = 1]" mode="#all">
    <!-- header row -->
  </xsl:template>

  <xsl:template match="ss:Row" mode="mets">
    <xsl:if test="ss:Cell[1]/ss:Data">

      <xsl:variable name="title"  select="ss:Cell[1]/ss:Data"/>
      <xsl:variable name="volume" select="ss:Cell[2]/ss:Data"/>
      <xsl:variable name="issueno"    select="ss:Cell[3]/ss:Data"/>
      <xsl:variable name="secondtitle" select="ss:Cell[4]/ss:Data"/>
      <xsl:variable name="callnum" select="ss:Cell[5]/ss:Data"/>
      <xsl:variable name="date" select="ss:Cell[6]/ss:Data"/>
      <xsl:variable name="keydate" select="ss:Cell[7]/ss:Data"/>
      <xsl:variable name="extent" select="ss:Cell[8]/ss:Data"/>
      <xsl:variable name="pcount" select="ss:Cell[9]/ss:Data"/>
      <xsl:variable name="boundp" select="ss:Cell[10]/ss:Data"/>
      <xsl:variable name="coversp" select="ss:Cell[11]/ss:Data"/>
      <xsl:variable name="notes" select="ss:Cell[12]/ss:Data"/>


      <xsl:variable name="issueString">
	<xsl:choose>
	  <xsl:when test="$secondtitle = 'Les Caracteres de la Dance'">03</xsl:when>
	  <xsl:when test="$issueno = 'supplement'">02</xsl:when>
	  <xsl:otherwise>01</xsl:otherwise>
	</xsl:choose>
      </xsl:variable>

      <xsl:variable name="basename">
	<xsl:value-of select="local:issueID($bmtnid, $keydate, $issueString)"/>
      </xsl:variable>

      <xsl:variable name="filename" select="concat($basename, '.mets.xml')" as="xs:string" />
      
      <xsl:variable name="filepath" select="concat(local:pathname($bmtnid, $keydate, $issueString), '/', $filename)" as="xs:string"/>

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
          <structMap>
            <div/>
          </structMap>

        </mets>

      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ss:Row" mode="mods">
    <xsl:param name="bmtnid" required="yes"/>
    <xsl:if test="ss:Cell[1]/ss:Data">
      <xsl:variable name="title"  select="ss:Cell[1]/ss:Data"/>
      <xsl:variable name="volume" select="ss:Cell[2]/ss:Data"/>
      <xsl:variable name="issueno"    select="ss:Cell[3]/ss:Data"/>
      <xsl:variable name="secondtitle" select="ss:Cell[4]/ss:Data"/>
      <xsl:variable name="callnum" select="ss:Cell[5]/ss:Data"/>
      <xsl:variable name="date" select="ss:Cell[6]/ss:Data"/>
      <xsl:variable name="keydate" select="ss:Cell[7]/ss:Data"/>
      <xsl:variable name="extent" select="ss:Cell[8]/ss:Data"/>
      <xsl:variable name="pcount" select="ss:Cell[9]/ss:Data"/>
      <xsl:variable name="boundp" select="ss:Cell[10]/ss:Data"/>
      <xsl:variable name="coversp" select="ss:Cell[11]/ss:Data"/>
      <xsl:variable name="notes" select="ss:Cell[12]/ss:Data"/>


      <xsl:variable name="issueString">
	<xsl:choose>
	  <xsl:when test="$secondtitle = 'Les Caracteres de la Dance'">03</xsl:when>
	  <xsl:when test="$issueno = 'supplement'">02</xsl:when>
	  <xsl:otherwise>01</xsl:otherwise>
	</xsl:choose>
      </xsl:variable>

      <xsl:variable name="basename">
	<xsl:value-of select="local:issueID($bmtnid, $keydate, $issueString)"/>
      </xsl:variable>

      <xsl:variable name="filename" select="concat($basename, '.mods.xml')" as="xs:string" />
      
      <xsl:variable name="filepath" select="concat(local:pathname($bmtnid, $keydate, $issueString), '/', $filename)" as="xs:string"/>

      <xsl:result-document href="{$filepath}">
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
            <title>
              <xsl:value-of select="$title"/>
            </title>
            <subTitle>
              <xsl:value-of select="$secondtitle"/>
            </subTitle>
          </titleInfo>
          <part type="issue">

            <detail type="volume">
              <xsl:value-of select="$volume"/>
            </detail>
            <detail type="number">
              <xsl:value-of select="$issueno"/>
            </detail>
            <extent unit="pages">
              <list>
                <xsl:value-of select="$extent"/>
              </list>
            </extent>
            <extent unit="pageimages">
              <total>
                <xsl:value-of select="$pcount"/>
              </total>
            </extent>
          </part>
          <originInfo>
            <dateIssued>
              <xsl:value-of select="$date"/>
            </dateIssued>
            <dateIssued keyDate="yes" encoding="iso8601">
              <xsl:value-of select="$keydate"/>
            </dateIssued>
          </originInfo>
          <location>
            <physicalLocation>SVL</physicalLocation>
            <holdingSimple>
              <copyInformation>
                <form>bound without covers</form>
                <shelfLocator><xsl:value-of select="$callnum"/></shelfLocator>
                <note>
                  <xsl:value-of select="$notes"/>
                </note>
              </copyInformation>
            </holdingSimple>
          </location>

	  <relatedItem type="host" xlink:type="simple"
		       xlink:href="urn:PUL:bluemountain:{$bmtnid}">
	    <recordInfo>
	      <recordIdentifier><xsl:value-of select="concat('urn:PUL:bluemountain:dmd:', $bmtnid)"/></recordIdentifier>
	    </recordInfo>
	  </relatedItem>
        </mods>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
