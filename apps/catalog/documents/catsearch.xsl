<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:local="http://diglib.princeton.edu"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:html="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="xs" version="2.0">
  
  <xsl:output
      method="xml"
      doctype-system="about:legacy-compat"
      encoding="UTF-8"
      indent="yes" />

  <xsl:template match="/">
    <html lang="en">
      <head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>Search Results</title>
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
	<nav>
	  <a href="{result/context/@url}">Home</a>
	</nav>
	</header>
	<div class="container-fluid">
	  <div class="row-fluid">
	    <div class="span2">
	      <p>sidebar</p>
	    </div>
	    <div class="span10">
	      <section>
		<h2><xsl:value-of select="concat(result/@hitcount, ' document(s) found for query ')"/>
		<i><xsl:value-of select="result/@query"/></i>
		</h2>
		<xsl:copy-of select="result/html:section/*"/>
	      </section>
	    </div>
	  </div>
	</div>
	<script src="http://code.jquery.com/jquery-latest.js"></script>
	<script src="js/bootstrap.min.js"></script>
      </body>
    </html>
  </xsl:template>


</xsl:stylesheet>
