<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:local="http://diglib.princeton.edu"
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
	<title>Lapidus Catalog</title>
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
	  <h1>The Sid Lapidus Digital Collection</h1>
	</header>
	<div class="container-fluid">
	  <div class="row-fluid">
	    <div class="span2">
	      <p>sidebar</p>
	    </div>
	    <div class="span10">
	      
		  <p>Listing <xsl:value-of select="docs/@count"/> document(s).</p>
		  <ol>
		    <xsl:apply-templates select="docs/doc"/>
		  </ol>

	    </div>
	  </div>
	</div>
	<script src="http://code.jquery.com/jquery-latest.js"></script>
	<script src="js/bootstrap.min.js"></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="doc">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  
  <xsl:template match="tei:monogr">
      <a href="{ancestor::doc/@id}">
	<xsl:value-of select="tei:title[@type='main']"/>
      </a>
    
  </xsl:template>

</xsl:stylesheet>
