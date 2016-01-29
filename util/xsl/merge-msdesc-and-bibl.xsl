<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:local="http://bluemountain.princeton.edu"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="xs math xd tei local" version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> January 29, 2016</xd:p>
      <xd:p><xd:b>Author:</xd:b> cwulfman</xd:p>
      <xd:p> Fork of the merge-msdec.xsl stylesheet. Given two TEI documents, one edited by staff
        (staff) and the other generated from the METS/ALTO/MODS (gen), merge the two, preserving the
        hand-crafted data produced by the editors. </xd:p>
      <xd:p> The procedure: apply the stylesheet to a generated document (or set of documents, as in
        Oxygen). The algorithm assumes parallel directory hierarchies/file naming in order to find
        the staff version. Take the facsimile and text elements from the generated document; for the
        TEI header, pick and choose from each source document: take the constituent elements from
        the generated document and the rest from the staff document. </xd:p>
    </xd:desc>
  </xd:doc>

  <xd:doc>
    <xd:desc>This is the hard-wired path to the msdesc-bearing documents. Edit this for your own
      environment.</xd:desc>
  </xd:doc>
  <xsl:variable name="msdesc-base"
    select="'/Users/cwulfman/repos/github/cwulfman/bluemountain-transcriptions'"/>

  <xd:doc>
    <xd:desc>Get the base uri when the stylesheet is first invoked.</xd:desc>
  </xd:doc>
  <xsl:variable name="source-base" select="base-uri()"/>

  <xsl:variable name="staff-path"
    select="concat($msdesc-base, substring-after(base-uri(current()), 'BlueMountain/metadata'))"
  />

  <xd:doc>
    <xd:desc> Take the &lt;msDesc&gt; from staffdoc; in the &lt;biblStruct&gt;, keep the
      &lt;monogr&gt;. </xd:desc>
  </xd:doc>
  <xsl:template match="tei:sourceDesc">
    <sourceDesc>
      
      <xsl:variable name="staffdoc" select="document($staff-path)"/>

      <xsl:copy-of select="$staffdoc//tei:msDesc"/>
      <xsl:apply-templates/>
    </sourceDesc>
  </xsl:template>


  <xsl:template match="tei:sourceDesc/tei:biblStruct">
    
    <xsl:variable name="staffdoc" select="document($staff-path)"/>
    <biblStruct>
      <xsl:copy-of
        select="$staffdoc//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr"/>
      <xsl:apply-templates select="tei:relatedItem"/>
    </biblStruct>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
