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

  <xsl:function name="local:displayform">
    <xsl:param name="mrec" />

      <xsl:variable name="link">
	<xsl:value-of select="concat('catalog/',substring-after($mrec/mods:identifier[@type='bmtn'],
			      'urn:PUL:bluemountain:'))"/>
      </xsl:variable>

      <xsl:variable name="title" select="$mrec/mods:titleInfo[empty(@type)]" as="element()"/>

      <xsl:variable name="titlestring">
	<xsl:if test="$title/mods:nonSort">
	  <xsl:value-of select="$title/mods:nonSort"/>
	  <xsl:text> </xsl:text>
	</xsl:if>
	<xsl:value-of select="normalize-space($title/mods:title)"/>
      </xsl:variable>


      <a href="{$link}"><span class="title"><xsl:value-of select="$titlestring"/></span></a>
	<xsl:apply-templates select="$mrec/mods:originInfo"/>
  </xsl:function>
  
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
	  span.title { font-size: larger; }
	  li.odd,li.even {margin: 5px }
	  li.odd { background:whitesmoke; }
	</style>
      </head>
      <body>
	<header>
	  <h1>The Blue Mountain Catalog</h1>
	</header>
	<div class="container-fluid">
	  <div class="row-fluid">
	    <div class="span2">
	      <h4>Facets Here?</h4>
	    </div>
	    <div class="span5">
	      
	      <p>Listing <xsl:value-of select="results/@count"/> title(s).</p>	
	      <ol>
		<xsl:for-each select="results/mods:mods">
		  <xsl:sort select="upper-case(normalize-space(mods:titleInfo[empty(@type)]/mods:title))" />
		  <li>
		    <xsl:attribute name="class">
		      <xsl:choose>
			<xsl:when test="(position() mod 2) = 0">even</xsl:when>
			<xsl:otherwise>odd</xsl:otherwise>
		      </xsl:choose>
		    </xsl:attribute>
		  <xsl:sequence select="local:displayform(.)"/>
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
  
  <xsl:template match="mods:originInfo">
    <xsl:variable name="pubPlace">
      <xsl:choose>
	<xsl:when test="count(mods:place) = 1">
	  <xsl:value-of select="mods:place/mods:placeTerm"/>
	</xsl:when>
	<xsl:when test="count(mods:place) = 2">
	  <xsl:value-of select="concat(mods:place[1]/mods:placeTerm, ' and ', mods:place[2]/mods:placeTerm)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:for-each select="mods:place">
	    <xsl:value-of select="mods:placeTerm"/>
	    <xsl:if test="position() != last()">
	      <xsl:text>, </xsl:text>
	    </xsl:if>
	  </xsl:for-each>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


      <xsl:value-of select="mods:dateIssued[empty(@point)]"/>

  </xsl:template>

</xsl:stylesheet>
