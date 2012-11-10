<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xlink="http://www.w3.org/1999/xlink"
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
	    <div class="span5">
	      <h2>Title</h2>
	      <xsl:apply-templates select="results/titleRec/mods:mods"/>
	    </div>
	    <div class="span5">
	      <h2>Constituents</h2>
	      <p>Found <xsl:value-of select="results/constituents/@count"/> issue(s).</p>
	      <ol>
		<xsl:for-each select="results/constituents/mods:mods">
		  <xsl:sort select="mods:originInfo/mods:dateIssued[@keyDate='yes']"/>
		  <li>
		    <xsl:choose>
		      <xsl:when test="mods:originInfo/mods:dateIssued[empty(@keyDate)]">
			<xsl:value-of select="mods:originInfo/mods:dateIssued[empty(@keyDate)]"/>
		      </xsl:when>
		      <xsl:otherwise>
			<xsl:value-of select="mods:originInfo/mods:dateIssued[@keyDate='yes']"/>			
		      </xsl:otherwise>
		    </xsl:choose>
		  </li>
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

  <xsl:template match="mods:mods">
    <xsl:variable name="ti" select="mods:titleInfo[empty(@type)]"/>
    <xsl:if test="$ti/mods:nonSort">
      <xsl:value-of select="$ti/mods:nonSort"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="normalize-space($ti/mods:title)"/>
  </xsl:template>

</xsl:stylesheet>
