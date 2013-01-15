<?xml version="1.0" encoding="UTF-8"?>
<!-- Oppidum Framework

    Author: Stéphane Sire <s.sire@free.fr>

    Returns a <site:view> for loading the AXEL editor.
    Template and Resource URI must be given with absolute path (no URL rewriting).

    OCtober 2011
 -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:site="http://oppidoc.com/oppidum/site"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="xml" media-type="text/html" omit-xml-declaration="yes" indent="yes"/>

  <xsl:param name="xslt.skin"></xsl:param>

  <xsl:template match="/">
    <site:view>
      <xsl:if test="$xslt.skin != ''">
        <xsl:attribute name="skin"><xsl:value-of select="$xslt.skin"/></xsl:attribute>
      </xsl:if>
      <site:menu>
        <button data-command="save" data-target="template-container">Save</button>
        <button data-command="preview" data-edit-label="Full editing">Preview</button>
      </site:menu>
      <site:content>
          <xsl:apply-templates select="*"/>
      </site:content>
    </site:view>
  </xsl:template>

  <xsl:template match="Edit[not(error)]">
    <div id="template-container" data-template="{Template}">
      <xsl:if test="Resource">
        <xsl:attribute name="data-src"><xsl:value-of select="Resource"/></xsl:attribute>
      </xsl:if>
      <p>Loading...</p>
    </div>
  </xsl:template>

  <xsl:template match="Edit[error]">
    <div>
      <p>Could not load the editor</p>
    </div>
  </xsl:template>

</xsl:stylesheet>
