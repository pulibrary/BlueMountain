<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" exclude-result-prefixes="xs ss"
    xmlns:local="http://diglib.princeton.edu" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="bmtnid" as="xs:string">bmtnaae</xsl:variable>


    <xsl:function name="local:issueID">
      <xsl:param name="bmtnID" as="xs:string"/>
      <xsl:param name="dateString" as="xs:string"/>

	<xsl:analyze-string select="$dateString" regex="([0-9]+)-?([0-9]+)?-?([0-9]+)?">
	  <xsl:matching-substring>
	    <xsl:variable name="year">
	      <xsl:choose>
		<xsl:when test="regex-group(1)">
		  <xsl:value-of select="regex-group(1)"/>
		</xsl:when>
		<xsl:otherwise>00</xsl:otherwise>
	      </xsl:choose>
	    </xsl:variable>
	    <xsl:variable name="month">
	      <xsl:choose>
		<xsl:when test="regex-group(2)">
		  <xsl:value-of select="regex-group(2)"/>
		</xsl:when>
		<xsl:otherwise>00</xsl:otherwise>
	      </xsl:choose>
	    </xsl:variable>
	    <xsl:variable name="day">
	      <xsl:choose>
		<xsl:when test="regex-group(3)">
		  <xsl:value-of select="regex-group(3)"/>
		</xsl:when>
		<xsl:otherwise>00</xsl:otherwise>
	      </xsl:choose>
	    </xsl:variable>
	    <xsl:value-of select="concat($year, '-', $month, '-', $day, '-01')"/>
	  </xsl:matching-substring>
	  <xsl:non-matching-substring>
	    <xsl:message terminate="yes" select="concat($dateString, ' does not match.')"/>
	  </xsl:non-matching-substring>
	</xsl:analyze-string>
    </xsl:function>

    <xsl:template match="ss:Workbook">
        <xsl:apply-templates select="ss:Worksheet/ss:Table/ss:Row" mode="mods"/>
        <xsl:apply-templates select="ss:Worksheet/ss:Table/ss:Row" mode="mets"/>
    </xsl:template>

    <xsl:template match="ss:Row[position() = 1]" mode="#all">
        <!-- header row -->
    </xsl:template>

    <xsl:template match="ss:Row" mode="mets">
        <xsl:if test="ss:Cell[1]/ss:Data">

            <xsl:variable name="title"           select="ss:Cell[1]/ss:Data"/>
            <xsl:variable name="secondtitle"     select="ss:Cell[2]/ss:Data"/>
            <xsl:variable name="volume"          select="ss:Cell[3]/ss:Data"/>
            <xsl:variable name="volumeCaption"   select="ss:Cell[4]/ss:Data"/>
            <xsl:variable name="issueno"         select="ss:Cell[5]/ss:Data"/>
            <xsl:variable name="issueCaption"    select="ss:Cell[6]/ss:Data"/>
            <xsl:variable name="keydate"         select="ss:Cell[7]/ss:Data"/>
            <xsl:variable name="datePrinted"     select="ss:Cell[8]/ss:Data"/>
            <xsl:variable name="extent"          select="ss:Cell[9]/ss:Data"/>
            <xsl:variable name="pcount"          select="ss:Cell[10]/ss:Data"/>
            <xsl:variable name="coversp"         select="ss:Cell[11]/ss:Data"/>
            <xsl:variable name="notes"           select="ss:Cell[12]/ss:Data"/>
            <xsl:variable name="genbib"          select="ss:Cell[13]/ss:Data"/>
            <xsl:variable name="other"           select="ss:Cell[14]/ss:Data"/>

            <xsl:variable name="basename">
	      <xsl:value-of select="concat($bmtnid, '_', local:issueID($bmtnid, $keydate))"/>
            </xsl:variable>

            <xsl:variable name="filename">
                <xsl:value-of
                    select="concat('/opt/local/BlueMountain/metadata/periodicals/', $bmtnid, '/issues/',$basename,'/',$basename,'.mets.xml' )"
                />
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
        </xsl:if>
    </xsl:template>

    <xsl:template match="ss:Row" mode="mods">
        <xsl:if test="ss:Cell[1]/ss:Data">

            <xsl:variable name="title"           select="ss:Cell[1]/ss:Data"/>
            <xsl:variable name="secondtitle"     select="ss:Cell[2]/ss:Data"/>
            <xsl:variable name="volume"          select="ss:Cell[3]/ss:Data"/>
            <xsl:variable name="volumeCaption"   select="ss:Cell[4]/ss:Data"/>
            <xsl:variable name="issueno"         select="ss:Cell[5]/ss:Data"/>
            <xsl:variable name="issueCaption"    select="ss:Cell[6]/ss:Data"/>
            <xsl:variable name="keydate"         select="ss:Cell[7]/ss:Data"/>
            <xsl:variable name="datePrinted"     select="ss:Cell[8]/ss:Data"/>
            <xsl:variable name="extent"          select="ss:Cell[9]/ss:Data"/>
            <xsl:variable name="pcount"          select="ss:Cell[10]/ss:Data"/>
            <xsl:variable name="coversp"         select="ss:Cell[11]/ss:Data"/>
            <xsl:variable name="notes"           select="ss:Cell[12]/ss:Data"/>
            <xsl:variable name="genbib"          select="ss:Cell[13]/ss:Data"/>
            <xsl:variable name="other"           select="ss:Cell[14]/ss:Data"/>


            <xsl:variable name="basename">
	      <xsl:value-of select="concat($bmtnid, '_', local:issueID($bmtnid, $keydate))"/>
            </xsl:variable>

            <xsl:variable name="filename">
                <xsl:value-of
                    select="concat('/opt/local/BlueMountain/metadata/periodicals/', $bmtnid, '/issues/',$basename,'/',$basename,'.mods.xml' )"
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

		    <titleInfo type="uniform">
		      <title>Dada (Zurich, Switzerland)</title>
		    </titleInfo>
                    <titleInfo>
                        <title>
                            <xsl:value-of select="$title"/>
                        </title>
                        <subTitle>
                            <xsl:value-of select="normalize-space($secondtitle)"/>
                        </subTitle>
                    </titleInfo>


                    <part type="issue">
		      <xsl:choose>
			<xsl:when test="($volume != '0') or ($volumeCaption != '0')">
                        <detail type="volume">
			  <xsl:if test="$volume and $volume &gt; 0">
			    <number><xsl:value-of select="$volume"/></number>			    
			  </xsl:if>
			  <xsl:if test="$volumeCaption and $volumeCaption != 0">
			    <caption><xsl:value-of select="$volumeCaption"/></caption>
			  </xsl:if>
			</detail>
			</xsl:when>
		      </xsl:choose>

		      <xsl:choose>
			<xsl:when test="($issueno != '0') or ($issueCaption != '0')">
                        <detail type="number">
			  <xsl:if test="$issueno">
			    <number><xsl:value-of select="$issueno"/></number>			    
			  </xsl:if>
			  <xsl:if test="$issueCaption">
			    <caption><xsl:value-of select="$issueCaption"/></caption>
			  </xsl:if>
			</detail>
			</xsl:when>
		      </xsl:choose>


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
                            <xsl:value-of select="$datePrinted"/>
                        </dateIssued>
                        <dateIssued keyDate="yes" encoding="w3cdtf">
                            <xsl:value-of select="$keydate"/>
                        </dateIssued>
                    </originInfo>

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
