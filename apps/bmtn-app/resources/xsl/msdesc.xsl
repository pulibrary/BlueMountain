<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd tei" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b> Jun 8, 2015</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:msDesc">
        <div id="msdesc">
            <div class="col-md-8">
                <xsl:apply-templates select="tei:physDesc"/>
            </div>
            <div class="col-md-4">
                <xsl:apply-templates select="tei:history"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:msIdentifier">
        <dl>
            <dt>Holding Institution</dt>
            <dd>
                <xsl:apply-templates select="tei:institution"/>
            </dd>
        </dl>
    </xsl:template>
    <xsl:template match="tei:physDesc">
        <div id="physDesc">
            <h2>Physical Description</h2>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:objectDesc">
        <div id="objectDesc">
            <h3>The Object</h3>
            <dl class="dl-horizontal">
                <dt>Form of Object</dt>
                <dd>
                    <xsl:value-of select="@form"/>
                </dd>
            </dl>
            <div class="row">
                <div class="col-md-6">
                    <xsl:apply-templates select="tei:supportDesc"/>
                </div>
                <div class="col-md-6">
                    <xsl:apply-templates select="tei:layoutDesc"/>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:supportDesc">
        <div id="supportDesc">
            <h4>Carrier (paper, etc.)</h4>
            <dl class="dl-horizontal">
                <dt>Supporting Material</dt>
                <dd>
                    <xsl:value-of select="@material"/>
                </dd>
            </dl>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:support">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:extent">
        <div id="extent">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:measure">
        <dl class="dl-horizontal">
            <dt>
                <xsl:value-of select="string-join((@unit, @type), ' ')"/>
            </dt>
            <dd>
                <xsl:apply-templates/>
            </dd>
        </dl>
    </xsl:template>
    <xsl:template match="tei:dimensions">
        <dl>
            <dt>
                <xsl:value-of select="string-join((@type, 'dimensions in', @unit), ' ')"/>
            </dt>
            <dd>
                <dl class="dl-horizontal">
                    <dt>width</dt>
                    <dd>
                        <xsl:apply-templates select="tei:width"/>
                    </dd>
                    <dt>height</dt>
                    <dd>
                        <xsl:apply-templates select="tei:height"/>
                    </dd>
                </dl>
            </dd>
        </dl>
    </xsl:template>
    <xsl:template match="tei:foliation">
        <dl class="dl-horizontal">
            <dt>foliation</dt>
            <dd>
                <xsl:apply-templates/>
            </dd>
        </dl>
    </xsl:template>
    <xsl:template match="tei:layoutDesc">
        <div id="layoutDesc">
            <h4>Layout</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:layout">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:typeDesc">
        <div id="typeDesk">
            <h3>Typography</h3>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:additions">
        <div id="additions">
            <h3>Additions</h3>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:bindingDesc">
        <div id="bindingDesc">
            <h3>Binding</h3>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:history">
        <div id="history">
            <h2>History of the Object</h2>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:measureGrp[@type = 'salesprice']">
        <table>
            <thead>
                <tr>
                    <th>unit</th>
                    <th>price</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="tei:measure">
                    <tr>
                        <td>
                            <xsl:value-of select="@unit"/>
                        </td>
                        <td>
                            <xsl:apply-templates/>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="tei:provenance">
        <div id="provenance">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
</xsl:stylesheet>