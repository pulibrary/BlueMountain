<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:local="http://diglib.princeton.edu"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="#all">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 8, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p>This stylesheet is part of the Blue Mountain Project.</xd:p>
            <xd:p>This stylesheet is used in the pre-production phase to generate preliminary, or
                &quot;stub,&quot; METS and MODS files for the issues of a periodical. It takes as
                input an <xd:i>excel spreadsheet transformed into xml</xd:i>.</xd:p>
        </xd:desc>
        <xd:return>A hierarchy of directories, organized by date of issuance, containing one METS
            and one MODS record for each mods:relatedItem element.</xd:return>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p>The identifier to be used as the base for all generated ids: bmtnabw</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="baseid" as="xs:string">bmtnabx</xsl:variable>

    <xd:doc>
        <xd:desc>
            <xd:p>The root of the path where files should be written. Defaults to
                <xd:i>/tmp</xd:i>.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="pathroot" as="xs:string">
        <xsl:text>/tmp</xsl:text>
    </xsl:param>

    <xd:doc>
        <xd:desc>
            <xd:p>Generates a formatted issue ID.</xd:p>
        </xd:desc>
        <xd:param name="baseid"/>
        <xd:param name="keyDate"/>
        <xd:param name="issueString"/>
        <xd:return>A string of the form <xd:i>bmtnID_KeyDate_issueString</xd:i></xd:return>
    </xd:doc>
    <xsl:function name="local:issueID" as="xs:string">
        <xsl:param name="baseid" as="xs:string"/>
        <xsl:param name="keyDate" as="xs:string"/>
        <xsl:param name="issueString" as="xs:string"/>
        <xsl:value-of
            select="concat($baseid, '_', $keyDate, '_', format-number(xs:integer($issueString), '00'))"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>
            <xd:p>Constructs a relative pathname rooted at the global $pathroot variable.</xd:p>
            <xd:p>Paths in the Blue Mountain storage tree has take the form
                    <xd:i>BMTNID/issues/ISSSUANCEPATH/OBJECTNAME</xd:i>, where <xd:ul>
                    <xd:li>BMTNID is a string of the form <xd:i>bmtnNNN</xd:i>, where
                            <xd:i>NNN</xd:i> is a hexavigesimal number (e.g., <xd:i>aaa, aab,
                            aac</xd:i>, etc.);</xd:li>
                    <xd:li>ISSUANCEPATH corresponds to the ISSUANCESTRING</xd:li>
                </xd:ul> See the Blue Mountain Reference documentation for details on the
                composition of Issuance Strings. </xd:p>
        </xd:desc>
        <xd:return>A string of the form pathroot/bmtnid/issues/(CCYY/MM/DD | CCYY/MM |
            CCYY)_II</xd:return>
        <xd:param name="bmtnID"/>

    </xd:doc>
    <xsl:function name="local:pathname" as="xs:string">
        <xsl:param name="keyDate" as="xs:string"/>
        <xsl:param name="issueString" as="xs:string"/>
        <!-- Construct the issuance path from the keydate by simply replacing the hyphen separators
    with slashes; e.g., 1921-04-01 will be converted to 1921/04/01-->
        <xsl:value-of
            select="
                concat(
                $pathroot,
                '/',
                $baseid,
                '/issues/',
                replace($keyDate, '-', '/'),
                '_',
                format-number(xs:integer($issueString), '00')
                )"/>

    </xsl:function>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="row">
        <xsl:variable name="issueid">
            <xsl:value-of select="local:issueID($baseid, Date__yyyy-mm-dd_, veridian_issue)"/>
        </xsl:variable>
        <xsl:variable name="basepath">
            <xsl:value-of select="local:pathname(Date__yyyy-mm-dd_, veridian_issue)"/>
        </xsl:variable>
        <xsl:variable name="filepath" select="concat($basepath, '/', $issueid, '.mods.xml')"
            as="xs:string"/>

        <xsl:result-document href="{$filepath}">
            <mods xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink">
                <identifier type="bmtn">
                    <xsl:value-of select="concat('urn:PUL:bluemountain:', $issueid)"/>
                </identifier>
                <recordInfo>
                    <recordIdentifier>
                        <xsl:value-of select="concat('urn:PUL:bluemountain:dmd:', $issueid)"/>
                    </recordIdentifier>
                </recordInfo>
                <typeOfResource>text</typeOfResource>
                <genre>Periodicals-Issue</genre>
                <titleInfo usage="primary" xml:lang="ru" script="cyrl">
                    <title>
                        <xsl:apply-templates select="Title__cyr_"/>
                    </title>
                    <xsl:if test="normalize-space(Subtitle__cyr_)">
                        <subTitle>
                            <xsl:apply-templates select="Subtitle__cyr_"/>
                        </subTitle>
                    </xsl:if>

                </titleInfo>
                <titleInfo xml:lang="ru" script="latn">
                    <title>
                        <xsl:apply-templates select="Title__Rom_"/>
                    </title>
                    <xsl:if test="normalize-space(Subtitle__Rom_)">
                        <subTitle>
                            <xsl:apply-templates select="Subtitle__Rom_"/>
                        </subTitle>
                    </xsl:if>
                </titleInfo>
                <part type="issue">
                    <xsl:if test="normalize-space(Volume__integer_)">> <detail type="volume">
                            <number>
                                <xsl:apply-templates select="Volume__integer_"/>
                            </number>
                            <caption script="latn">
                                <xsl:apply-templates select="Date__label___Rom_"/>
                            </caption>
                            <caption script="cyrl">
                                <xsl:apply-templates select="Date__label___cyr_"/>
                            </caption>
                        </detail>
                    </xsl:if>
                    <detail type="number">
                        <xsl:for-each select="tokenize(Issue__integer_, ' - ')">
                            <number>
                                <xsl:value-of select="current()"/>
                            </number>
                        </xsl:for-each>
                        <caption script="latn">
                            <xsl:apply-templates select="Issue__label___Rom_"/>
                        </caption>
                        <caption script="cyrl">
                            <xsl:apply-templates select="Issue__label___cyr_"/>
                        </caption>
                    </detail>
                </part>
                <originInfo>
                    <dateIssued script="latn">
                        <xsl:apply-templates select="Date__label___Rom_" />
                    </dateIssued>
                    <dateIssued script="cyrl">
                        <xsl:apply-templates select="Date__label___cyr_" />
                    </dateIssued>
                    <dateIssued keyDate="yes" encoding="w3cdtf">
                        <xsl:apply-templates select="Date__yyyy-mm-dd_" />
                    </dateIssued>
                </originInfo>
                <location>
                    <physicalLocation type="text">Princeton University</physicalLocation>
                    <physicalLocation authority="marcorg" type="code">NjP</physicalLocation>
                    <holdingSimple>
                        <copyInformation>
                            <subLocation>RECAP: Marquand Library (Rare) use only</subLocation>
                            <shelfLocator>NX556.A1 A65</shelfLocator>
                        </copyInformation>
                    </holdingSimple>
                </location>
                <relatedItem type="host" xlink:type="simple" xlink:href="urn:PUL:bluemountain:{$baseid}"/>
            </mods>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="row-old">
        <relatedItem type="constituent">
            <xsl:if test="./veridian_issue &gt; 1">
                <identifier type="bmtn">
                    <xsl:value-of
                        select="concat('urn:PUL:bluemountain:bmtnabw_', ./Date__yyyy-mm-dd_, '_', format-number(xs:integer(./veridian_issue), '00'))"
                    />
                </identifier>
            </xsl:if>
            <titleInfo usage="primary" xml:lang="ru" script="cyrl">
                <title>
                    <xsl:apply-templates select="Title__cyr_"/>
                </title>
                <subTitle>
                    <xsl:apply-templates select="Subtitle__cyr_"/>
                </subTitle>
            </titleInfo>
            <titleInfo xml:lang="ru" script="latn">
                <title>
                    <xsl:apply-templates select="Title__Rom_"/>
                </title>
                <subTitle>
                    <xsl:apply-templates select="Subtitle__Rom_"/>
                </subTitle>
            </titleInfo>
            <part type="issue">
                <detail type="volume">
                    <number>
                        <xsl:apply-templates select="Volume__integer_"/>
                    </number>
                    <caption script="latn">
                        <xsl:apply-templates select="Volume__label_"/>
                    </caption>
                </detail>
                <detail type="number">
                    <number>
                        <xsl:apply-templates select="Issue__integer_"/>
                    </number>
                    <caption>
                        <xsl:apply-templates select="Issue__label_"/>
                    </caption>
                </detail>
            </part>
            <originInfo>
                <dateIssued>
                    <xsl:apply-templates select="Date__label_"/>
                </dateIssued>
                <dateIssued keyDate="yes" encoding="w3cdtf">
                    <xsl:apply-templates select="Date__yyyy-mm-dd_"/>
                </dateIssued>
            </originInfo>
        </relatedItem>
    </xsl:template>
</xsl:stylesheet>
