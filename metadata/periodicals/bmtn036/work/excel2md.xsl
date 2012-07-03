<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" exclude-result-prefixes="xs ss"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="bmtnid" as="xs:string">bmtn036</xsl:variable>
    <xsl:variable name="mdroot" as="xs:string">/opt/local/BlueMountain/metadata/periodicals/</xsl:variable>


    <xsl:template match="ss:Workbook">
        <xsl:apply-templates select="ss:Worksheet" mode="mods"/>
        <xsl:apply-templates select="ss:Worksheet" mode="mets"/>
    </xsl:template>

    <xsl:template match="ss:Worksheet" mode="mets">
        <xsl:apply-templates select="ss:Table/ss:Row" mode="#current"/>
    </xsl:template>

    <xsl:template match="ss:Worksheet" mode="mods">
        <xsl:apply-templates select="ss:Table/ss:Row" mode="#current"/>
    </xsl:template>

    <xsl:template match="ss:Row[position() = 1]" mode="#all">
        <!-- header row; skip it. -->
    </xsl:template>

    <xsl:template match="ss:Row" mode="mets">
        <xsl:if test="ss:Cell[1]/ss:Data">
            <xsl:variable name="title"  select="ss:Cell[1]/ss:Data"/>
            <xsl:variable name="volume" select="ss:Cell[2]/ss:Data"/>
            <xsl:variable name="issueno"    select="ss:Cell[3]/ss:Data"/>
            <xsl:variable name="secondtitle" select="ss:Cell[4]/ss:Data"/>
            <xsl:variable name="callno" select="ss:Cell[5]/ss:Data"/>
            <xsl:variable name="date" select="ss:Cell[6]/ss:Data"/>
            <xsl:variable name="keydate" select="ss:Cell[7]/ss:Data"/>
            <xsl:variable name="extent" select="ss:Cell[8]/ss:Data"/>
            <xsl:variable name="pagecount" select="ss:Cell[9]/ss:Data"/>
            <xsl:variable name="boundp" select="ss:Cell[10]/ss:Data"/>
            <xsl:variable name="coverp" select="ss:Cell[11]/ss:Data"/>
            <xsl:variable name="notes" select="ss:Cell[12]/ss:Data"/>

	    <xsl:variable name="issuelabel">
	      <xsl:choose>
		<xsl:when test="number($issueno) = number($issueno)">
		  <xsl:value-of select="format-number($issueno, '00')"/>
		</xsl:when>
		<xsl:when test="$issueno = 'supplement'">
		  <xsl:value-of select="concat('supplement-', $keydate)"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="$issueno"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:variable>

            <xsl:variable name="basename">
                <xsl:value-of
                    select="concat($bmtnid,'-', format-number($volume,'00'), $issuelabel)"
                />
	    </xsl:variable>
            <xsl:variable name="filename">
                <xsl:value-of
                    select="concat($mdroot, $bmtnid, '/issues/',$basename,'/',$basename,'.mets.xml' )"
                />
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
            <xsl:variable name="title"  select="ss:Cell[1]/ss:Data"/>
            <xsl:variable name="volume" select="ss:Cell[2]/ss:Data"/>
            <xsl:variable name="issueno"    select="ss:Cell[3]/ss:Data"/>
            <xsl:variable name="secondtitle" select="ss:Cell[4]/ss:Data"/>
            <xsl:variable name="callno" select="ss:Cell[5]/ss:Data"/>
            <xsl:variable name="date" select="ss:Cell[6]/ss:Data"/>
            <xsl:variable name="keydate" select="ss:Cell[7]/ss:Data"/>
            <xsl:variable name="extent" select="ss:Cell[8]/ss:Data"/>
            <xsl:variable name="pagecount" select="ss:Cell[9]/ss:Data"/>
            <xsl:variable name="boundp" select="ss:Cell[10]/ss:Data"/>
            <xsl:variable name="coverp" select="ss:Cell[11]/ss:Data"/>
            <xsl:variable name="notes" select="ss:Cell[12]/ss:Data"/>

	    <xsl:variable name="issuelabel">
	      <xsl:choose>
		<xsl:when test="number($issueno) = number($issueno)">
		  <xsl:value-of select="format-number($issueno, '00')"/>
		</xsl:when>
		<xsl:when test="$issueno = 'supplement'">
		  <xsl:value-of select="concat('supplement-', $keydate)"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="$issueno"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:variable>

            <xsl:variable name="basename">
                <xsl:value-of
                    select="concat($bmtnid,'-', format-number($volume,'00'), $issuelabel)"
                />
            </xsl:variable>
            <xsl:variable name="filename">
                <xsl:value-of
                    select="concat($mdroot, $bmtnid, '/issues/',$basename,'/',$basename,'.mods.xml' )"
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
                        <title><xsl:value-of select="$title"/></title>
                    </titleInfo>
                    <part type="issue">

                        <detail level="1">
                            <number><xsl:value-of select="$volume"/></number>
                        </detail>
                        <detail level="2">
			  <xsl:choose>
			    <xsl:when test="$issueno = 'supplement'">
			      <title><xsl:value-of select="$secondtitle"/></title>
			    </xsl:when>
			    <xsl:otherwise>
			      <number><xsl:value-of select="$issueno"/></number>
			    </xsl:otherwise>
			  </xsl:choose>
                            
                        </detail>
                        <extent unit="pages">
                            <list> </list>
                        </extent>
                        <extent unit="pageimages">
                            <total> </total>
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

                    <relatedItem type="host" xlink:type="simple"
                        xlink:href="urn:PUL:bluemountain:{$bmtnid}">
                        <recordInfo>
                            <recordIdentifier>
                                <xsl:value-of select="concat('urn:PUL:bluemountain:dmd:', $bmtnid)"
                                />
                            </recordIdentifier>

                        </recordInfo>
                    </relatedItem>

                </mods>
            </xsl:result-document>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
