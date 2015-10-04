<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:math="http://www.w3.org/2005/xpath-functions/math"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:local="http://bluemountain.princeton.edu"
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns = "http://www.tei-c.org/ns/1.0"
	
	exclude-result-prefixes="xs math xd tei local" version="3.0">
	<xd:doc scope="stylesheet">
		<xd:desc>
			<xd:p><xd:b>Created on:</xd:b> Oct 3, 2015</xd:p>
			<xd:p><xd:b>Author:</xd:b> cwulfman</xd:p>
			<xd:p/>
		</xd:desc>
	</xd:doc>


	<xsl:variable name="msdesc-base" select="'/Users/cwulfman/Projects/bluemountain-transcriptions'"/>
	<xsl:variable name="source-base" select="base-uri()"/>

	<xsl:function name="local:the-msDesc">
		<xsl:variable name="path">
			<xsl:value-of
				select="concat($msdesc-base, substring-after(base-uri(current()), 'BlueMountain/metadata'))"
			/>
		</xsl:variable>
		<xsl:sequence select="document($path)//tei:msDesc" />
	</xsl:function>


	
	
	<xsl:template match="tei:sourceDesc">
		<sourceDesc>
			<xsl:variable name="path">
				<xsl:value-of
					select="concat($msdesc-base, substring-after(base-uri(current()), 'BlueMountain/metadata'))"
				/>
			</xsl:variable>
			<xsl:variable name="mydoc" select="document($path)"/>
	
				<xsl:copy-of select="$mydoc//tei:msDesc"/>
			<xsl:apply-templates />
		</sourceDesc>
	</xsl:template>	
	
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
