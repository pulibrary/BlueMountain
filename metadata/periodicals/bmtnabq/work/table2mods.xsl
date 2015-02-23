<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:local="http://diglib.princeton.edu"
    xmlns="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="xs xd"
    version="2.0">
        
    <xsl:output method="xml" indent="yes"/>

    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 16, 2015</xd:p>
            <xd:p><xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:variable name="pathroot" as="xs:string">/tmp</xsl:variable>
    <xsl:variable name="urnprefix">urn:PUL:bluemountain</xsl:variable>
    <xsl:variable name="bmtnid">bmtnabq</xsl:variable>
    
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
    
    <xsl:function name="local:issueID">
        <xsl:param name="bmtnID" as="xs:string"/>
        <xsl:param name="keyDate" as="xs:string" />
        <xsl:param name="issueString" as="xs:string"/>
        
        <xsl:value-of select="concat(
            $bmtnID,
            '_',
            $keyDate,
            '_',
            format-number(xs:integer($issueString), '00'),
            '.mods.xml'
            )"/>
    </xsl:function>
    
    <xsl:template match="/">
        <xsl:for-each select="root/row">
            <xsl:variable name="path" select="concat(local:pathname($bmtnid, ./Date__yyyy-mm-dd_, ./veridian_issue), '/', local:issueID($bmtnid, ./Date__yyyy-mm-dd_, ./veridian_issue))"/>
            <xsl:result-document href="{$path}">
                <xsl:apply-templates select="."/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <!--
    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="root">
        <modsCollection nxmlns="http://www.loc.gov/mods/v3">
            <xsl:apply-templates />
        </modsCollection>
    </xsl:template>
    -->
    <xsl:template match="row">
        <mods>
            <recordInfo>
                <recordIdentifier>
                    <xsl:value-of select="concat($urnprefix,':dmd:',$bmtnid, '_', Date__yyyy-mm-dd_,'_', veridian_issue)" />
                </recordIdentifier>
            </recordInfo>
            <identifier type="bmtn">
                <xsl:value-of select="concat($urnprefix,':',$bmtnid, '_', Date__yyyy-mm-dd_,'_', veridian_issue)" />
            </identifier>
            <typeOfResource>text</typeOfResource>
            <genre>Periodicals-Issue</genre>
            <titleInfo>
                <nonSort>
                    <xsl:value-of select="substring-before(Title, ' ')"/>
                </nonSort>
                <title>
                    <xsl:value-of select="substring-after(Title, ' ')"/>
                </title>
                <subTitle>
                    <xsl:value-of select="Subtitle"/>
                </subTitle>
            </titleInfo>
            <part type="issue">
                <detail type="volume">
                    <number><xsl:value-of select="Volume__integer_"/></number>
                    <caption><xsl:value-of select="Volume__label_"/></caption>
                </detail>
                <detail type="number">
                    <number><xsl:value-of select="Issue__integer_" /></number>
                    <caption><xsl:value-of select="Issue__label_" /></caption>
                </detail>
                <date><xsl:value-of select="Date__label_" /></date>
            </part>
            <originInfo>
	      <dateIssued keyDate="yes" encoding="iso8601"><xsl:value-of select="Date__yyyy-mm-dd_" /></dateIssued>
            </originInfo>
            <location>
                <physicalLocation type="text">
                    Princeton University Library
                </physicalLocation>
                <physicalLocation authority="marcorg" type="code">NjP</physicalLocation>
                <holdingSimple>
                    <copyInformation>
                        <subLocation>rcppa</subLocation>
                        <shelfLocator>0902.962</shelfLocator>
                    </copyInformation>
                </holdingSimple>
            </location>
            <relatedItem type="host" xlink:type="simple" xlink:href="urn:PUL:bluemountain:{$bmtnid}">
                <recordInfo>
                    <recordIdentifier><xsl:value-of select="concat('urn:PUL:bluemountain:dmd:', $bmtnid)" /></recordIdentifier>
                </recordInfo>
            </relatedItem>
            
        </mods>
    </xsl:template>
    
</xsl:stylesheet>
