<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" exclude-result-prefixes="xs ss"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="bmtnid" as="xs:string">bmtn029</xsl:variable>


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
        <!-- header row -->
    </xsl:template>

    <xsl:template match="ss:Row" mode="mets">
        <xsl:if test="ss:Cell[1]/ss:Data">
            <xsl:variable name="volume" select="ss:Cell[1]/ss:Data"/>
            <xsl:variable name="issueno" select="ss:Cell[2]/ss:Data"/>
            <xsl:variable name="date" select="ss:Cell[3]/ss:Data"/>
            <xsl:variable name="keydate" select="ss:Cell[4]/ss:Data"/>

            <xsl:variable name="basename">
                <xsl:value-of
                    select="concat($bmtnid, '-', format-number($volume,'00'), format-number($issueno,'00'))"
                />
            </xsl:variable>

            <xsl:variable name="filename">
                <xsl:value-of
                    select="concat('/tmp/', $bmtnid, '/issues/',$basename,'/',$basename,'.mets.xml' )"
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
            <xsl:variable name="volume" select="ss:Cell[1]/ss:Data"/>
            <xsl:variable name="issueno" select="ss:Cell[2]/ss:Data"/>
            <xsl:variable name="date" select="ss:Cell[3]/ss:Data"/>
            <xsl:variable name="keydate" select="ss:Cell[4]/ss:Data"/>

            <xsl:variable name="basename">
                <xsl:value-of
                    select="concat($bmtnid,'-', format-number($volume,'00'), format-number($issueno,'00'))"
                />
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
                        <nonSort>La</nonSort>
                        <title>Chronique musicale</title>
                    </titleInfo>
                    <part type="issue">

                        <detail type="volume">
                            <xsl:value-of select="$volume"/>
                        </detail>
                        <detail type="number">
                            <xsl:value-of select="$issueno"/>
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
