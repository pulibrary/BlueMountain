<?xml version="1.0" encoding="utf-8"?>

<!-- Transform new MJP TEI file into simple web page -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:local="http://diglib.princeton.edu"
		xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="xs" version="2.0">
  
  <xsl:output
      method="xml"
      doctype-system="about:legacy-compat"
      encoding="UTF-8"
      indent="yes" />
  
  <xsl:key name="surfaces"
	   match="//tei:TEI/tei:facsimile/tei:surface"
	   use="@xml:id"/>
  


  <!-- Algorithm from http://wiki.tei-c.org/index.php/Milestone-chunk.xquery -->
  <xsl:function name="local:milestone-chunk" as="node()*">
    <xsl:param name="ms1" as="element()"/>
    <xsl:param name="ms2" as="element()?"/>
    <xsl:param name="node" as="node()"/>
  
    <xsl:variable name="chunk">
    <xsl:choose>
      <xsl:when test="$node/self::*"> <!-- When the node is an element -->
        <xsl:choose>
          <xsl:when test="$node is $ms1">
            <xsl:copy-of select="$node" copy-namespaces="yes"/>
          </xsl:when>
          <xsl:when
            test="some $n in $node/descendant::* satisfies ($n is $ms1 or $n is $ms2)">
           <xsl:element name="{local-name($node)}" namespace="{namespace-uri($node)}">
              
                <xsl:for-each select="$node/node() | $node/@*">
                <xsl:sequence select="local:milestone-chunk($ms1, $ms2, current())" />
              </xsl:for-each>
            </xsl:element>
          </xsl:when>
          <xsl:when test="$node &gt;&gt; $ms1 and $node &lt;&lt; $ms2">
            <xsl:copy-of select="$node" copy-namespaces="yes"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="count($node|$node/../@*) = count($node/../@*)"> <!-- When the node is an attribute -->
        <xsl:copy-of select="$node" copy-namespaces="yes"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$node &gt;&gt; $ms1 and $node &lt;&lt; $ms2">
            <xsl:copy-of select="$node" copy-namespaces="yes"/>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="$chunk"/>
  </xsl:function>
  
  <xsl:template match="/">
    <html lang="en">
      <head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>sample</title>
      </head>
      <body>
	<xsl:apply-templates />
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="tei:TEI">
    <section>
      <xsl:apply-templates select="tei:teiHeader"/>
    </section>
    <section>
      <xsl:apply-templates select="tei:text" />
    </section>
  </xsl:template>

  <xsl:template match="tei:teiHeader">
    <xsl:apply-templates select="tei:fileDesc/tei:sourceDesc" />
  </xsl:template>

  <xsl:template match="tei:sourceDesc">
    <header>
            <xsl:apply-templates select="tei:biblStruct/tei:monogr"/>
    </header>
    <nav>
      <ul>
	<xsl:for-each select="tei:biblStruct/tei:relatedItem[@type='constituent']">
	  <li><xsl:apply-templates select="current()"/></li>
	</xsl:for-each>
      </ul>
    </nav>
  </xsl:template>

  <xsl:template match="tei:monogr">
    <h1><xsl:apply-templates select="tei:title"/></h1>
  </xsl:template>

  <xsl:template match="tei:relatedItem[@type='constituent']">
    <xsl:variable name="title" select="tei:biblStruct/tei:analytic/tei:title"/>
    <xsl:variable name="byline">
      <xsl:apply-templates select="tei:biblStruct/tei:analytic/tei:respStmt"/>
    </xsl:variable>
    <xsl:variable name="page" select="tokenize(tei:biblStruct/tei:monogr/tei:imprint/tei:biblScope/@corresp, ' ')[1]"/>
    <a href="#{$page}"><xsl:value-of select="concat($title, ' . . . ', $byline)"/></a>
  </xsl:template>

  <xsl:template match="tei:respStmt">
    <xsl:apply-templates select="tei:persName"/>
  </xsl:template>
  
  <xsl:template match="tei:text">
    <table>
      <xsl:apply-templates /> 
    </table>
 
  </xsl:template>

  <xsl:template match="tei:front">
    <xsl:variable name="pbs"  select=".//tei:pb"/>

      <xsl:for-each select="$pbs">
        <xsl:variable name="pb2-pos" select="position() +1" />
  
        <tr>
           <td>
              <xsl:choose>
                <xsl:when test="$pbs[$pb2-pos]">
                  <xsl:apply-templates select="local:milestone-chunk(current(), $pbs[$pb2-pos], ./ancestor::tei:front)" mode="render"/>
                </xsl:when>

                <xsl:otherwise>
                  <xsl:apply-templates select="current()/following-sibling::element()" mode="render"/>
                </xsl:otherwise>
              </xsl:choose>
              
            </td>
          <td>
            <a name="{@facs}"/>
            <img src = "{key('surfaces', @facs)/tei:graphic[@ana='lowres']/@url}" alt="page"/>
          </td>
        </tr>
      </xsl:for-each>
    
  </xsl:template>

  <xsl:template match="tei:body">
    <xsl:variable name="pbs"  select=".//tei:pb"/>
   
      <xsl:for-each select="$pbs">
        <xsl:variable name="pb2-pos" select="position() +1" />
  
        <tr>
           <td>
              <xsl:choose>
                <xsl:when test="$pbs[$pb2-pos]">
                  <xsl:apply-templates select="local:milestone-chunk(current(), $pbs[$pb2-pos], ./ancestor::tei:body)" mode="render"/>
                </xsl:when>

                <xsl:otherwise>
<!--                  <xsl:apply-templates select="current()/following::element()" mode="render"/> -->
                  <xsl:apply-templates select="local:milestone-chunk(current(), current()/following::element()[last()], ./ancestor::tei:body)" mode="render"/>
                </xsl:otherwise>
              </xsl:choose>
              
            </td>
          <td>
            <a name="{@facs}"/>
            <img src = "{key('surfaces', @facs)/tei:graphic[@ana='lowres']/@url}" alt="page"/>
          </td>
        </tr>
      </xsl:for-each>
    
  </xsl:template>
  
  <xsl:template match="tei:text" mode="render">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
<!--
  <xsl:template match="tei:pb">
    <xsl:variable name="pagetext">
      <xsl:choose>
        <xsl:when test="./following-sibling::tei:pb">
          <xsl:value-of select="./following::node()/text() intersect ./following-sibling::tei:pb[1]/preceding::node()/text()"/>	  
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="./following::node()" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr>
      <td>
        <p><xsl:value-of select="$pagetext"/></p>
      </td>
      <td>
        <a name="{@facs}"/>
        <img src = "{key('surfaces', @facs)/tei:graphic[@ana='lowres']/@url}" alt="page"/>
      </td>
    </tr>
  </xsl:template>
-->
  <xsl:template match="tei:p" mode="render">
    <p><xsl:apply-templates mode="#current"/></p>
  </xsl:template>

  <xsl:template match="tei:lb" mode="render">
    <br />
  </xsl:template>

  <xsl:template match="tei:salute" mode="render">
    <p><xsl:apply-templates mode="#current"/></p>
  </xsl:template>
</xsl:stylesheet>
