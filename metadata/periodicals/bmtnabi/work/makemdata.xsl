<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" exclude-result-prefixes="xs ss"
    xmlns:local="http://diglib.princeton.edu"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>


    <xsl:variable name="bmtnid" as="xs:string">bmtnabi</xsl:variable>

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

    
    <xsl:function name="local:keyDate">
      <xsl:param name="dateString" as="xs:string"/>

        <xsl:analyze-string select="$dateString" regex="(\d+)\.\s+(\w+)\s+(\d+)">
          <xsl:matching-substring>
            <xsl:variable name="month">
              <xsl:choose>
                <xsl:when test="matches(regex-group(2), 'Januar', 'i')"
                          >01</xsl:when>
                <xsl:when test="matches(regex-group(2), 'Februar', 'i')"
                          >02</xsl:when>
                <xsl:when test="matches(regex-group(2), 'März', 'i')"
                          >03</xsl:when>
                <xsl:when test="matches(regex-group(2), 'April', 'i')"
                          >04</xsl:when>
                <xsl:when test="matches(regex-group(2), 'Mai', 'i')"
                          >05</xsl:when>
                <xsl:when test="matches(regex-group(2), 'Juni', 'i')"
                          >06</xsl:when>
                <xsl:when test="matches(regex-group(2), 'Juli', 'i')"
                          >07</xsl:when>
                <xsl:when test="matches(regex-group(2), 'Aug*', 'i')"
                          >08</xsl:when>
                <xsl:when test="matches(regex-group(2), 'Sep*', 'i')"
                          >09</xsl:when>
                <xsl:when test="matches(regex-group(2), 'Oct*', 'i')"
                          >10</xsl:when>
                <xsl:when test="matches(regex-group(2), 'Nov*', 'i')"
                          >11</xsl:when>
                <xsl:when test="matches(regex-group(2), 'Dec*', 'i')"
                          >12</xsl:when>
                <xsl:otherwise><xsl:message terminate="yes">Month doesn't match.</xsl:message></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

              <xsl:value-of
                  select="xs:date(concat(regex-group(3), '-', $month, '-', format-number(number(regex-group(1)), '00')))"
                  />

          </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>

    <!-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -->

    <xsl:template match="ss:Workbook">
        <xsl:apply-templates select="ss:Worksheet" mode="mods"/>
        <xsl:apply-templates select="ss:Worksheet" mode="mets"/>
    </xsl:template>

    <xsl:template match="ss:Row[position() = 1]" mode="#all">
        <!-- header row -->
    </xsl:template>

    <xsl:template match="ss:Row" mode="mets">
        <xsl:if test="ss:Cell[1]/ss:Data">
            <xsl:variable name="title" select="ss:Cell[1]/ss:Data"/>
            <xsl:variable name="volume" select="ss:Cell[2]/ss:Data"/>
            <xsl:variable name="issueno" select="ss:Cell[3]/ss:Data"/>
            <xsl:variable name="secondtitle" select="ss:Cell[4]/ss:Data"/>
            <xsl:variable name="callnum" select="ss:Cell[5]/ss:Data"/>
            <xsl:variable name="date" select="ss:Cell[6]/ss:Data"/>
            <xsl:variable name="pcount" select="ss:Cell[7]/ss:Data"/>
            <xsl:variable name="extent" select="ss:Cell[8]/ss:Data"/>
            <xsl:variable name="boundp" select="ss:Cell[9]/ss:Data"/>
            <xsl:variable name="coversp" select="ss:Cell[10]/ss:Data"/>
            <xsl:variable name="notes" select="ss:Cell[11]/ss:Data"/>

	    <xsl:variable name="veridianIssue">1</xsl:variable>

	    <xsl:variable name="keyDateString" select="local:keyDate($date)" />

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
            <xsl:variable name="volume" select="ss:Cell[2]/ss:Data"/>
            <xsl:variable name="issueno" select="ss:Cell[3]/ss:Data"/>
            <xsl:variable name="secondtitle" select="ss:Cell[4]/ss:Data"/>
            <xsl:variable name="callnum" select="ss:Cell[5]/ss:Data"/>
            <xsl:variable name="date" select="ss:Cell[6]/ss:Data"/>
            <xsl:variable name="pcount" select="ss:Cell[7]/ss:Data"/>
            <xsl:variable name="extent" select="ss:Cell[8]/ss:Data"/>
            <xsl:variable name="boundp" select="ss:Cell[9]/ss:Data"/>
            <xsl:variable name="coversp" select="ss:Cell[10]/ss:Data"/>
            <xsl:variable name="notes" select="ss:Cell[11]/ss:Data"/>

	    <xsl:variable name="veridianIssue">1</xsl:variable>

	    <xsl:variable name="keyDateString" select="local:keyDate($date)" />


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
                        <title>Niederrheinische Musik</title>
                        <subTitle>Zeitung für Kunstfreunde und Künstler</subTitle>
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
		      <dateIssued keyDate="yes" encoding="w3cdtf">
                        <xsl:value-of select="$keyDateString"/>
                      </dateIssued>
                    </originInfo>

                    <location>
                        <physicalLocation>SVL</physicalLocation>
                        <holdingSimple>
                            <copyInformation>
                                <form>bound without covers</form>
                                <shelfLocator>ML5.N55</shelfLocator>
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
