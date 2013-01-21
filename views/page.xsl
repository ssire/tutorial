<?xml version="1.0" encoding="UTF-8"?>
<!-- Oppidum : tutorial

    Author: Stéphane Sire <s.sire@oppidoc.fr>

    Renders a page following a quite simple page model
    Returns a <site:view> document

    January 2013
 -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:site="http://oppidoc.com/oppidum/site"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="xml" media-type="text/html" omit-xml-declaration="yes" indent="no"/>
  
  <xsl:param name="xslt.rights"></xsl:param>  
  <xsl:param name="xslt.base-url">/</xsl:param> 
  
  <xsl:template match="/">
    <site:view>
      <xsl:if test="$xslt.rights != ''">
        <site:menu>
          <xsl:if test="contains($xslt.rights, 'modifier')">
            <button title="Modifier la page" onclick="javascript:window.location.href+='/modifier'">Modifier</button>
          </xsl:if>
        </site:menu>
      </xsl:if>
      <site:content>
        <xsl:apply-templates select="Page/Title | Page/Parag | Page/Illustration"/>
      </site:content>
    </site:view>  
  </xsl:template>
  
  <xsl:template match="Title">
    <h1><xsl:value-of select="."/></h1>
  </xsl:template>

  <xsl:template match="Parag">
    <p><xsl:value-of select="."/></p>
  </xsl:template>

  <!-- Writes images URL so that they are rooted in a single 'images' resource at site's top level -->
  <xsl:template match="Illustration">
    <p><img class="illustration" src="{$xslt.base-url}{@src}"/></p>
  </xsl:template>
  
</xsl:stylesheet>
