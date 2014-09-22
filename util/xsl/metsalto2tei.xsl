<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
 xmlns="http://www.tei-c.org/ns/1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:alto="http://www.loc.gov/standards/alto/ns-v2#" 
 xmlns:tei="http://www.tei-c.org/ns/1.0"
 xmlns:mets="http://www.loc.gov/METS/" 
 xmlns:mods="http://www.loc.gov/mods/v3"
 xmlns:local="http://library.princeton.edu/cew" 
 exclude-result-prefixes="xs alto mets local xlink" 
 version="2.0">
 
 <xsl:import href="alto2tei.xsl"/> 
 <xsl:import href="mods2tei.xsl"/>


 <xsl:strip-space elements="*"/>
 <xsl:output indent="yes"/>



<xsl:param name="path"></xsl:param>
 <!--
 <xsl:variable name="path" as="xs:string"
  >/opt/local/BlueMountain/metadata/periodicals/bmtnaab/issues/1920/02_01/</xsl:variable>
-->
 
 <xsl:key name="files" match="mets:file" use="@ID"/>

 <xsl:function name="local:altopath">
  <xsl:param name="rawpath"/>
<!--  <xsl:value-of select="replace($rawpath, 'file://./', $path)"/> -->
  <xsl:value-of select="replace($rawpath, 'file://.', $path)"/>
 </xsl:function>
 

 <xsl:template match="mets:mets">
  <TEI xmlns="http://www.tei-c.org/ns/1.0">
   <teiHeader>
    <fileDesc>
     <titleStmt>
      <title>Later</title>
     </titleStmt>
     <publicationStmt>
      <publisher>Princeton University</publisher>
      <!--      <idno type="bmtnid"><xsl:value-of select="@OBJID" /></idno> -->
      <idno type="bmtnid"><xsl:value-of select="./mets:dmdSec//mods:identifier[@type='bmtn']" /></idno>
     </publicationStmt>
     <seriesStmt>
      <title level="s">The Blue Mountain Project</title>
     </seriesStmt>
    <sourceDesc>
      <xsl:apply-templates select="mets:dmdSec[@ID='dmd1']/mets:mdWrap/mets:xmlData/mods:mods"/>
    </sourceDesc>
    </fileDesc>
   </teiHeader>

<!--   <facsimile>
    <xsl:apply-templates select="mets:structMap[@TYPE='PHYSICAL']" mode="facsimile"/>
   </facsimile>-->

   <text>

    <body>
      <!--      <xsl:apply-templates select="mets:structMap[@TYPE='PHYSICAL']"/> -->
      <xsl:apply-templates select="mets:structMap[@TYPE='LOGICAL']"/> 
    </body>
   </text>
  
  </TEI>

 </xsl:template>

 <xsl:template match="mets:structMap[@TYPE='PHYSICAL']" mode="facsimile">
  <xsl:apply-templates mode="#current"/>
 </xsl:template>

 <xsl:template match="mets:structMap[@TYPE='PHYSICAL']">
  <xsl:apply-templates mode="#current"/>
 </xsl:template>

 <xsl:template match="mets:structMap[@TYPE='LOGICAL']" mode="#all">
  <xsl:apply-templates mode="logical"/>
 </xsl:template>


 <xsl:template match="mets:div" mode="logical">
   <div type="{@TYPE}">
     <xsl:if test="@DMDID">
       <xsl:attribute name="corresp" select="@DMDID"/>
     </xsl:if>
       <xsl:apply-templates mode="#current"/>
   </div>
 </xsl:template>
<!--
 <xsl:template match="mets:div" mode="#all">
  <xsl:apply-templates mode="#current"/>
 </xsl:template>
-->

 <xsl:template match="mets:fptr" mode="#all">
  <xsl:apply-templates mode="#current"/>
 </xsl:template>

 <xsl:template match="mets:par" mode="#all">
  <xsl:apply-templates mode="#current"/>
 </xsl:template>

<!--
 <xsl:template match="mets:area[@BETYPE = 'IDREF']" mode="#all">
  <xsl:variable name="altopath"
   select="local:altopath(key('files', @FILEID)/mets:FLocat/@xlink:href)"/>
  <xsl:apply-templates select="document($altopath)//alto:Page" mode="#current" />
 </xsl:template>
 -->

<xsl:template match="mets:area[@BETYPE = 'IDREF']" mode="#all">
   <xsl:variable name="start">
     <xsl:value-of select="./@BEGIN" />
   </xsl:variable>
  <xsl:variable name="altopath"
   select="local:altopath(string(key('files', @FILEID)/mets:FLocat/@xlink:href))"/>

  <xsl:apply-templates select="document($altopath)//node()[@ID=$start]" mode="#current" />
 </xsl:template>


</xsl:stylesheet>



