<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" 
    xmlns:local="http://diglib.princeton.edu"
    exclude-result-prefixes="xs ss"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>


    <xsl:variable name="bmtnid" as="xs:string">bmtnabi</xsl:variable>
    <xsl:variable name="pathroot" as="xs:string">/tmp</xsl:variable>


    <xsl:function name="local:issueIDasVolIssue">
      <xsl:param name="bmtnID" as="xs:string"/>
      <xsl:param name="volString" as="xs:integer"/>
      <xsl:param name="issueString" as="xs:string"/>
      <xsl:value-of select="concat($bmtnID, '_', format-number($volString, '00'), '-', $issueString)"/>
    </xsl:function>

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

    <xsl:template match="ss:Workbook">
      <xsl:apply-templates select="ss:Worksheet/ss:Table/ss:Row" mode="mods"/>
      <xsl:apply-templates select="ss:Worksheet/ss:Table/ss:Row" mode="mets"/>
    </xsl:template>

    <xsl:template match="ss:Row[position() = 1]" mode="#all">
        <!-- header row -->
    </xsl:template>

    <xsl:template match="ss:Row" mode="mets">
        <xsl:if test="ss:Cell[1]/ss:Data">
            <xsl:variable name="title" select="ss:Cell[1]/ss:Data"/>
            <xsl:variable name="subtitle" select="ss:Cell[2]/ss:Data"/>
            <xsl:variable name="volume" select="ss:Cell[3]/ss:Data"/>
            <xsl:variable name="volumeLabel" select="ss:Cell[4]/ss:Data"/>
            <xsl:variable name="issueno" select="ss:Cell[5]/ss:Data"/>
            <xsl:variable name="issuenoLabel" select="ss:Cell[6]/ss:Data"/>
            <xsl:variable name="keyDate" select="ss:Cell[7]/ss:Data"/>
            <xsl:variable name="dateLabel" select="ss:Cell[8]/ss:Data"/>
            <xsl:variable name="veridianIssue" select="ss:Cell[9]/ss:Data"/>

	    <xsl:variable name="keyDateString">
	      <xsl:choose>
		<xsl:when test="$keyDate/@ss:Type = 'DateTime'">
		  <xsl:value-of select="substring-before($keyDate, 'T')"/>
		</xsl:when>
		<xsl:otherwise><xsl:value-of select="$keyDate"/></xsl:otherwise>
	      </xsl:choose>
	    </xsl:variable>

            <xsl:variable name="basename">
                <xsl:value-of select="local:issueID($bmtnid, $keyDateString, $veridianIssue)"/>
            </xsl:variable>

	    <xsl:variable name="filename" select="concat($basename, '.mets.xml')" as="xs:string" />

	    <xsl:variable name="filepath" select="concat(local:pathname($bmtnid, $keyDateString, $veridianIssue), '/', $filename)" as="xs:string"/>

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

        <xsl:if test="ss:Cell[1]/ss:Data">
            <xsl:variable name="title" select="ss:Cell[1]/ss:Data"/>
            <xsl:variable name="subtitle" select="ss:Cell[2]/ss:Data"/>
            <xsl:variable name="volume" select="ss:Cell[3]/ss:Data"/>
            <xsl:variable name="volumeLabel" select="ss:Cell[4]/ss:Data"/>
            <xsl:variable name="issueno" select="ss:Cell[5]/ss:Data"/>
            <xsl:variable name="issuenoLabel" select="ss:Cell[6]/ss:Data"/>
            <xsl:variable name="keyDate" select="ss:Cell[7]/ss:Data"/>
            <xsl:variable name="dateLabel" select="ss:Cell[8]/ss:Data"/>
            <xsl:variable name="veridianIssue" select="ss:Cell[9]/ss:Data"/>

	    <xsl:variable name="keyDateString">
	      <xsl:choose>
		<xsl:when test="$keyDate/@ss:Type = 'DateTime'">
		  <xsl:value-of select="substring-before($keyDate, 'T')"/>
		</xsl:when>
		<xsl:otherwise><xsl:value-of select="$keyDate"/></xsl:otherwise>
	      </xsl:choose>
	    </xsl:variable>

            <xsl:variable name="basename">
                <xsl:value-of select="local:issueID($bmtnid, $keyDateString, $veridianIssue)"/>
            </xsl:variable>

	    <xsl:variable name="filename" select="concat($basename, '.mods.xml')" as="xs:string" />

	    <xsl:variable name="filepath" select="concat(local:pathname($bmtnid, $keyDateString, $veridianIssue), '/', $filename)" as="xs:string"/>

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
                        <title><xsl:value-of select="$title"/></title>
                     <xsl:if test="$subtitle != '[none]'">
                        <subTitle><xsl:value-of select="$subtitle"/></subTitle>
                     </xsl:if>
                    </titleInfo>

                    <part type="issue">
                      <detail type="volume">
                        <number>
			  <xsl:value-of select="$volume"/>
			</number>
			<caption><xsl:value-of select="$volumeLabel"/></caption>
                      </detail>
                      <detail type="number">
			<number>
                          <xsl:value-of select="$issueno"/>
			</number>
			<caption><xsl:value-of select="$issuenoLabel"/></caption>
                      </detail>
                    </part>
                    <originInfo>
                      <dateIssued>
                        <xsl:value-of select="$dateLabel"/>
                      </dateIssued>
		      <dateIssued keyDate="yes" encoding="w3cdtf">
                        <xsl:value-of select="$keyDateString"/>
                      </dateIssued>
                    </originInfo>
		    <location>
		      <physicalLocation>New York Public Library</physicalLocation>
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
