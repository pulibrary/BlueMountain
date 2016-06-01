<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://www.loc.gov/mods/v3" xmlns:mets="http://www.loc.gov/METS/">
    <!-- IdentityTransform -->
    <!-- Created by Jennifer Goslee (luxlunae@gmail.com) for Blue Mountain Project on 05-05-2016 -->
    
    
    <!-- This script copies an entire mets file.  It finds unbound illustrations that are children of bound illustrations,
        and moves the "image" and "caption" divs to the parent.  It marks but does not change those illustration divs if 
        there is more than one of them in the parent-->
    <xsl:template match="/ | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- This template matches unbound illustration divs WITH illustration siblings -->
    <xsl:template
        match='mets:div[(@TYPE="Illustration") and (count(./mets:div[@TYPE="Illustration"]) > 1) ]/mets:div[@TYPE="Illustration" and not(@DMDID)]'>
        <xsl:comment>This constituent has multiple child illustrations, the first is unbound</xsl:comment>
        <xsl:comment>No changes made by the transformation script</xsl:comment>
        <xsl:text>&#xa;</xsl:text>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- This template matches unbound illustration divs with no illustration siblings and makes the modification-->
    <xsl:template
        match='mets:div[(@TYPE="Illustration") and (count(./mets:div[@TYPE="Illustration"])=1) ]/mets:div[@TYPE="Illustration" and not(@DMDID)]'>
        <xsl:comment>Unbound Illustration Div removed</xsl:comment>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates select="mets:div"/>
    </xsl:template>
</xsl:stylesheet>


