<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mets="http://www.loc.gov/METS/"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:local="http://diglib.princeton.edu"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="#all">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Mar 1, 2014</xd:p>
      <xd:p><xd:b>Author:</xd:b> cwulfman</xd:p>
      <xd:p>This stylesheet is part of the Blue Mountain Project.</xd:p>
      <xd:p>This stylesheet is used in the pre-production phase to generate preliminary, or
        &quot;stub,&quot; METS and MODS files for the issues of a periodical. It takes as input a
          <xd:i>title-level MODS record</xd:i> that contains a series of mods:relatedItem elements
        of the <xd:i>constituent</xd:i> type.</xd:p>
    </xd:desc>
    <xd:return>A hierarchy of directories, organized by date of issuance, containing one METS and
      one MODS record for each mods:relatedItem element.</xd:return>
  </xd:doc>


  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xd:doc>
    <xd:desc>
      <xd:p>The identifier to be used as the base for all generated ids: bmtnaab, bmtnaac,
        etc.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:variable name="bmtnid" as="xs:string"
    select="substring-after(/mods:mods/mods:identifier[@type='bmtn'], 'urn:PUL:bluemountain:')"/>


  <xd:doc>
    <xd:desc>
      <xd:p>The root of the path where files should be written. Defaults to
        <xd:i>/tmp</xd:i>.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:param name="pathroot" as="xs:string">
    <xsl:text>/tmp</xsl:text>
  </xsl:param>


  <xd:doc>
    <xd:desc>
      <xd:p>Generates a formatted issue ID.</xd:p>
    </xd:desc>
    <xd:param name="bmtnID"/>
    <xd:param name="keyDate"/>
    <xd:param name="issueString"/>
    <xd:return>A string of the form <xd:i>bmtnID_KeyDate_issueString</xd:i></xd:return>
  </xd:doc>
  <xsl:function name="local:issueID" as="xs:string">
    <xsl:param name="bmtnID" as="xs:string"/>
    <xsl:param name="keyDate" as="xs:string"/>
    <xsl:param name="issueString" as="xs:string"/>
    <xsl:value-of
      select="concat($bmtnID, '_', $keyDate, '_', format-number(xs:integer($issueString), '00'))"/>
  </xsl:function>

  <xd:doc>
    <xd:desc>
      <xd:p>Constructs a relative pathname rooted at the global $pathroot variable.</xd:p>
      <xd:p>Paths in the Blue Mountain storage tree has take the form
          <xd:i>BMTNID/issues/ISSSUANCEPATH/OBJECTNAME</xd:i>, where <xd:ul>
          <xd:li>BMTNID is a string of the form <xd:i>bmtnNNN</xd:i>, where <xd:i>NNN</xd:i> is a
            hexavigesimal number (e.g., <xd:i>aaa, aab, aac</xd:i>, etc.);</xd:li>
          <xd:li>ISSUANCEPATH corresponds to the ISSUANCESTRING</xd:li>
        </xd:ul> See the Blue Mountain Reference documentation for details on the composition of
        Issuance Strings. </xd:p>
    </xd:desc>
    <xd:return>A string of the form pathroot/bmtnid/issues/(CCYY/MM/DD | CCYY/MM |
      CCYY)_II</xd:return>
    <xd:param name="bmtnID"/>
    <xd:param name="keyDate"/>
    <xd:param name="issueString"/>
  </xd:doc>
  <xsl:function name="local:pathname" as="xs:string">
    <xsl:param name="bmtnID" as="xs:string"/>
    <xsl:param name="keyDate" as="xs:string"/>
    <xsl:param name="issueString" as="xs:string"/>
    <!-- Construct the issuance path from the keydate by simply replacing the hyphen separators
    with slashes; e.g., 1921-04-01 will be converted to 1921/04/01-->
    <xsl:value-of
      select="concat(
			    $pathroot,
			    '/',
			    $bmtnID,
			    '/issues/',
			    replace($keyDate, '-', '/'),
			    '_',
			    format-number(xs:integer($issueString), '00')
			    )"
    />
  </xsl:function>


  <xd:doc>
    <xd:desc>
      <xd:p>Constructs the base name for the issue represented by the $relItem parameter: that is,
        bmtn_date_issuance.</xd:p>
    </xd:desc>
    <xd:param name="relItem">
      <xd:p>A relatedItem element</xd:p>
    </xd:param>
    <xd:return>A string of the form bmtnid_DATE_ISSUANCE.</xd:return>
  </xd:doc>
  <xsl:function name="local:basename" as="xs:string">
    <xsl:param name="relItem" as="element()"/>
    <xsl:variable name="keyDateString"
      select="$relItem/mods:originInfo/mods:dateIssued[@keyDate='yes']"/>
    <!-- Each relatedItem MUST have a keydate of issuance. -->
    <xsl:variable name="givenid" select="$relItem/mods:identifier[@type='bmtn']"/>
    <!-- The encoder may override construction of an issuance
    string by providing one manually: in particular, when there are multiple editions
    (e.g., two issues in the same month). -->
    <xsl:choose>
      <xsl:when test="$givenid">
        <xsl:value-of select="substring-after($givenid, 'urn:PUL:bluemountain:')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="local:issueID($bmtnid, $keyDateString, '01')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xd:doc>
    <xd:desc>
      <xd:p>Computes the issuance string for the issue. If the MODS relatedItem element contains an
        explicit ID, the function returns the issuance part of it; otherwise, it defaults to
        01.</xd:p>
    </xd:desc>
    <xd:param name="relItem" />
    <xd:return>A string of the form NN.</xd:return>
  </xd:doc>
  <xsl:function name="local:issueString" as="xs:string">
    <xsl:param name="relItem" as="element()"/>
    <xsl:variable name="givenid" select="$relItem/mods:identifier[@type='bmtn']"/>
    <!-- The encoder may override construction of an issuance
    string by providing one manually: in particular, when there are multiple editions
    (e.g., two issues in the same month). -->

    <xsl:choose>
      <xsl:when test="$givenid">
        <xsl:value-of select="tokenize(substring-after($givenid, 'urn:PUL:bluemountain:'), '_')[3]"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>01</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xd:doc>
    <xd:desc>
      <xd:p>The top-level template in the stylesheet. It processes the set of relatedItem elements
        twice: once in "mods" mode and once in "mets" mode, to generate the MODS documents and the
        METS documents, respectively.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="mods:mods">
    <xsl:apply-templates select="mods:relatedItem[@type='constituent']" mode="mods"/>
    <xsl:apply-templates select="mods:relatedItem[@type='constituent']" mode="mets"/>
  </xsl:template>

  <xd:doc>
    <xd:desc>
      <xd:p>Constructs a simple METS element with a bunch of boilerplate filled in, and
      including the appropriate identifier strings.  Emits this record as a result-document.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="mods:relatedItem[@type='constituent']" mode="mets">
    <xsl:variable name="keyDateString" select="mods:originInfo/mods:dateIssued[@keyDate='yes']"/>
    <!-- Each relatedItem MUST have a keydate of issuance. -->

    <xsl:variable name="basename" as="xs:string" select="local:basename(.)"/>
    <xsl:variable name="issueString" as="xs:string" select="local:issueString(.)"/>

    <xsl:result-document
      href="{concat(local:pathname($bmtnid, $keyDateString, $issueString), '/', $basename, '.mets.xml')}">
      <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
        TYPE="Periodical-Issue" OBJID="urn:PUL:bluemountain:{$basename}">
        <metsHdr>
          <agent ROLE="CREATOR" TYPE="ORGANIZATION">
            <name>Princeton University Library, Digital Initiatives</name>
          </agent>
        </metsHdr>
        <metsDocumentID TYPE="URN">
          <xsl:value-of select="concat('urn:PUL:bluemountain:td:',$basename)"/>
        </metsDocumentID>
        <dmdSec ID="dmd1">
          <mdRef LOCTYPE="URN" MDTYPE="MODS" MIMETYPE="application/mods+xml"
            xlink:href="{concat('urn:PUL:bluemountain:dmd:',$basename)}"/>
        </dmdSec>
        <structMap TYPE="PHYSICAL">
          <div/>
        </structMap>
        <structMap TYPE="LOGICAL">
          <div/>
        </structMap>
      </mets>
    </xsl:result-document>
  </xsl:template>

  <xd:doc>
    <xd:desc>
      <xd:p>Constructs a simple MODS element from the contents of the relatedItem element.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="mods:relatedItem[@type='constituent']" mode="mods">
    <xsl:variable name="keyDateString" select="mods:originInfo/mods:dateIssued[@keyDate='yes']"/>
    <!-- Each relatedItem MUST have a keydate of issuance. -->

    <xsl:variable name="basename" as="xs:string" select="local:basename(.)"/>
    <xsl:variable name="issueString" as="xs:string" select="local:issueString(.)"/>

    <xsl:variable name="filepath"
      select="concat(local:pathname($bmtnid, $keyDateString, $issueString), '/', $basename, '.mods.xml')"
      as="xs:string"/>

    <xsl:result-document href="{$filepath}">
      <mods xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink">
        <recordInfo>
          <recordIdentifier>
            <xsl:value-of select="concat('urn:PUL:bluemountain:dmd:', $basename)"/>
          </recordIdentifier>
        </recordInfo>
        <identifier type="bmtn">
          <xsl:value-of select="concat('urn:PUL:bluemountain:',$basename)"/>
        </identifier>
        <typeOfResource>text</typeOfResource>
        <genre>Periodicals-Issue</genre>

        <!-- If the relatedItem contains a titleInfo element, copy it; otherwise,
        copy the top-level titleInfo element. -->
        <xsl:choose>
          <xsl:when test="mods:titleInfo">
            <xsl:copy-of select="mods:titleInfo" copy-namespaces="no"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="ancestor::mods:mods/mods:titleInfo" copy-namespaces="no"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:copy-of select="mods:part" copy-namespaces="no"/>
        <xsl:copy-of select="mods:originInfo" copy-namespaces="no"/>
        <xsl:copy-of select="mods:location" copy-namespaces="no"/>
        <xsl:copy-of select="mods:note" copy-namespaces="no"/>
        <relatedItem type="host" xlink:type="simple" xlink:href="urn:PUL:bluemountain:{$bmtnid}">
          <recordInfo>
            <recordIdentifier>
              <xsl:value-of select="concat('urn:PUL:bluemountain:dmd:', $bmtnid)"/>
            </recordIdentifier>
          </recordInfo>
        </relatedItem>
      </mods>
    </xsl:result-document>
  </xsl:template>

</xsl:stylesheet>
