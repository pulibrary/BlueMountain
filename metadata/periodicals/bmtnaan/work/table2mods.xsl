<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output indent="yes"></xsl:output>
    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="row">
        <relatedItem type="constituent">
            <xsl:if test="./veridian_issue &gt; 1">
                <identifier type='bmtn'>
                    <xsl:value-of select="concat('urn:PUL:bluemountain:bmtnaan_', ./Date__yyyy-mm-dd_, '_', format-number(xs:integer(./veridian_issue), '00'))" />
                </identifier>
            </xsl:if>
            <titleInfo>
                <title>
                    <xsl:apply-templates select="Title" />
                </title>
                <subTitle>
                    <xsl:apply-templates select="Subtitle" />
                </subTitle>
            </titleInfo>
            <part type="issue">
                <detail type="volume">
                    <number>
                        <xsl:apply-templates select="Volume__integer_" />
                    </number>
                    <caption>
                        <xsl:apply-templates select="Volume__label_" />
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
                    <xsl:apply-templates select="Date__label_" />
                </dateIssued>
                <dateIssued keyDate="yes" encoding="w3cdtf">
                    <xsl:apply-templates select="Date__yyyy-mm-dd_" />
                </dateIssued>
            </originInfo>
        </relatedItem>
    </xsl:template>
</xsl:stylesheet>