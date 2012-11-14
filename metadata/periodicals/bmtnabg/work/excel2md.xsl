<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" 
    xmlns:local="http://diglib.princeton.edu"
    exclude-result-prefixes="xs ss"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>


    <xsl:variable name="bmtnid" as="xs:string">bmtnabg</xsl:variable>

    <!-- Obsolete? -->
    <xsl:function name="local:issueID">
      <xsl:param name="bmtnID" as="xs:string"/>
      <xsl:param name="volString" as="xs:integer"/>
      <xsl:param name="issueString" as="xs:string"/>
      <xsl:value-of select="concat($bmtnID, '_', format-number($volString, '00'), '-', $issueString)"/>
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

            <xsl:variable name="basename">
                <xsl:value-of select="local:issueID($bmtnid, $volume, $issueno)"/>
            </xsl:variable>

            <xsl:variable name="filename">
                <xsl:value-of
                    select="concat('/tmp/', $bmtnid, '/issues/', $basename, '/', $basename, '.mets.xml' )"/>
            </xsl:variable>

            <xsl:result-document href="{$filename}">
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

            <xsl:variable name="basename">
                <xsl:value-of select="local:issueID($bmtnid, $volume, $issueno)"/>
            </xsl:variable>

            <xsl:variable name="filename">
                <xsl:value-of
                    select="concat('/tmp/', $bmtnid, '/issues/', $basename, '/', $basename, '.mods.xml' )"/>
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
                        <title><xsl:value-of select="$title"/></title>
                        <subTitle><xsl:value-of select="$subtitle"/></subTitle>
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
                        <xsl:value-of select="$keyDate"/>
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
