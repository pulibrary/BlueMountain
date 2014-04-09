<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
		xmlns='http://erlangen-crm.org/efrbroo/'
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:mods="http://www.loc.gov/mods/v3"
		xmlns:mets="http://www.loc.gov/METS/"
		xmlns:bmtn='http://blaueberg.info/'
		xmlns:dc='http://purl.org/dc/terms/'
		xmlns:efrbroo='http://erlangen-crm.org/efrbroo/'
		xmlns:ns0='http://www.w3.org/2004/02/skos/'
		xmlns:owl='http://www.w3.org/2002/07/owl#'
		xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
		xmlns:rdfs='http://www.w3.org/2000/01/rdf-schema#'
		xmlns:skos='http://www.w3.org/2004/02/skos/core#'
		xmlns:xsd='http://www.w3.org/2001/XMLSchema#'
		xmlns:local="http://library.princeton.edu">
  
  <xsl:output indent="yes"></xsl:output>


  <xsl:variable name="bmtnid"
		select="substring-after(/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:identifier[@type='bmtn'], 'urn:PUL:bluemountain:')"/>


  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates select="//mods:mods" />
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="mods:mods">
    <!-- a typical bibliographic record for a publication (not a
         manuscript) reflects the notion of F3 Manifestation Product
         Type -->
    <F3_Manifestation_Product_Type rdf:about="http://blaueberg.info/F3/{$bmtnid}">
      <dc:title>
  	<xsl:apply-templates select="mods:titleInfo[1]" />
	<xsl:if test="mods:part[@type='issue']">
	  <xsl:variable name="partString">
	    <xsl:apply-templates select="mods:part[@type='issue']"/>
	  </xsl:variable>
	    <xsl:value-of select="concat(' ', $partString)" />
	</xsl:if>
      </dc:title>
      <dc:date>
  	<xsl:apply-templates select="mods:originInfo/mods:dateIssued[@keyDate='yes']" />
      </dc:date>
      <CLR6_should_carry>
	<F24_Publication_Expression rdf:about="http://blaueberg.info/F24/{$bmtnid}">
	  <R14_incorporates>
	    <F22_Self_Contained_Expression rdf:about="http://blaueberg.info/F22/{$bmtnid}/0"/>
	  </R14_incorporates>
	</F24_Publication_Expression>
      </CLR6_should_carry>
    </F3_Manifestation_Product_Type>

    <xsl:apply-templates select="mods:relatedItem[@type='constituent']" />

  </xsl:template>

  <xsl:template match="mods:relatedItem[@type='constituent']">
    <xsl:variable name="constituentID" select="@ID" />

    <F22_Self_Contained_Expression rdf:about="http://blaueberg.info/F22/{$bmtnid}/{$constituentID}">
      <R14i_is_incorporated_in>
	<F22_Self_Contained_Expression rdf:about="http://blaueberg.info/F22/{$bmtnid}/0"/>
      </R14i_is_incorporated_in>
      <P102_has_title>

  	<xsl:apply-templates select="mods:titleInfo[1]" />
	<xsl:if test="mods:part[@type='issue']">
	  <xsl:variable name="partString">
	    <xsl:apply-templates select="mods:part[@type='issue']"/>
	  </xsl:variable>
	    <xsl:value-of select="concat(' ', $partString)" />
	</xsl:if>

      </P102_has_title>
      <xsl:for-each select="mods:name">
	<xsl:variable name="i" select="position()" />

      <R17i_was_created_by>
	<F28_Expression_Creation rdf:about="http://blaueberg.info/F28/{$bmtnid}/{$constituentID}/{$i}">
	  <E14_carried_out_by>
	    <E21_Person>
	      <P1131_is_identified_by>
		<xsl:apply-templates select="mods:displayForm"/>
	      </P1131_is_identified_by>
	    </E21_Person>
<!--	    <P14.1_in_the_role_of>
	      <xsl:value-of select="mods:role/mods:roleTerm/text()"/>
	    </P14.1_in_the_role_of> -->
	  </E14_carried_out_by>
	</F28_Expression_Creation>
      </R17i_was_created_by>


      </xsl:for-each>
    </F22_Self_Contained_Expression>
  </xsl:template>

  <xsl:template match="mods:titleInfo">
    <xsl:if test="mods:nonSort">
      <xsl:value-of select="concat(mods:nonSort/text(), ' ')"/>
    </xsl:if>
    <xsl:value-of select="mods:title/text()" />
    <xsl:if test="mods:subTitle">
      <xsl:value-of select="concat(' (', mods:subTitle/text(),')')"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mods:part[@type='issue']">
    <xsl:value-of select="concat(mods:detail[@type='volume']/mods:number/text(), ':' , mods:detail[@type='number']/mods:number/text())" />
  </xsl:template>

</xsl:stylesheet>
