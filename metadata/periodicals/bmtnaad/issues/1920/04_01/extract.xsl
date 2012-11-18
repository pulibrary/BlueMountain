<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:mets="http://www.loc.gov/METS/"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:mods="http://www.loc.gov/mods/v3"
		xmlns="http://www.loc.gov/METS/"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" exclude-result-prefixes="xs ss"
		xmlns:local="http://diglib.princeton.edu"
		>

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>


    <xsl:template match="mets:mets">
      <tei:TEI>
	<tei:teiHeader>
	  
	</tei:teiHeader>
	<tei:text>
	  <xsl:apply-templates select="mets:structMap" />
	</tei:text>
      </tei:TEI>
    </xsl:template>

    <xsl:template match="mets:div">
      <xsl:value-of select="@LABEL"/>
    	<xsl:apply-templates />
    </xsl:template>

</xsl:stylesheet>
