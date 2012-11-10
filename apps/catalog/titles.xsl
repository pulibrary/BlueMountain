<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:local="http://diglib.princeton.edu"
		xmlns:mods="http://www.loc.gov/mods/v3"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:html="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="#all" version="2.0">
  
  <xsl:output
      method="html"
      doctype-public="about:legacy-compat"
      encoding="UTF-8"
      omit-xml-declaration="yes"
      indent="yes" />

  <xsl:template match="/">
    <html lang="en">
      <head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>Blue Mountain Catalog</title>
	<!-- Bootstrap -->
        <link href="css/bootstrap.min.css" rel="stylesheet"/>

	<style type="text/css">
	  div.result p { font-size: small; }
	  header {background:black; color: white;}
	  span.hi {background:yellow;}
	  p.odd,p.even {margin: 3px;}
	  p.odd { background:whitesmoke; }
	</style>
      </head>
      <body>
	<header>
	  <h1>The Blue Mountain Catalog</h1>
	</header>
	<div class="container-fluid">
	  <div class="row-fluid">
	    <div class="span2">
	      <p>sidebar</p>
	    </div>
	    <div class="span10">
	      	
	      <p>Listing <xsl:value-of select="results/@count"/> document(s).</p>	
		  <ol>
		  	<xsl:for-each select="results/mods:mods">
		  		<xsl:sort select="upper-case(normalize-space(mods:titleInfo[empty(@type)]/mods:title))" />
		  		<xsl:variable name="link">
		  			<xsl:value-of select="concat('catalog/', substring-after(mods:identifier[@type='bmtn'], 'urn:PUL:bluemountain:'))"/>
		  		</xsl:variable>
		  		<li><a href="{$link}">
		  			<xsl:if test="mods:titleInfo[empty(@type)]/mods:nonSort">
		  				<xsl:value-of select="mods:titleInfo[empty(@type)]/mods:nonSort"/>
		  				<xsl:text> </xsl:text>
		  			</xsl:if>
		  			<xsl:value-of select="normalize-space(mods:titleInfo[empty(@type)]/mods:title)"/>
		  		</a></li>
		  	</xsl:for-each>
		  </ol>

	    </div>
	  </div>
	</div>
	<script src="http://code.jquery.com/jquery-latest.js"></script>
	<script src="js/bootstrap.min.js"></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="results">
  		<ol>

  			
  		</ol>
    <xsl:apply-templates select="mods:mods"/>
  </xsl:template>

  <xsl:template match="mods:mods">
    <xsl:for-each select="mods:titleInfo[empty(@type)]">
      <xsl:sort select="mods:title"/>
      <xsl:variable name="link">
	<xsl:value-of select="substring-after('urn:PUL:bluemountain:', mods:identifier[@type='bmtn'])"/>
      </xsl:variable>
      <li><a href="{$link}">
	<xsl:if test="mods:nonSort">
	  <xsl:value-of select="mods:nonSort"/>
	  <xsl:text> </xsl:text>
	</xsl:if>
	<xsl:value-of select="normalize-space(mods:title)"/>
      </a></li>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
