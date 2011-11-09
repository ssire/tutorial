<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:xt="http://ns.inria.org/xtiger">

  <xsl:output method="xml" media-type="text/xml" omit-xml-declaration="yes" indent="no"/> 

	<xsl:param name="xslt.base-url">/</xsl:param>	

  <!-- Replaces photo_URL and adds photo_base in attribute param in order 
  	   to use a single image collection for the whole site rooted at site's top level -->
  <xsl:template match="@param[parent::xt:attribute[@types='photo']]">
  	<xsl:variable name="value"><xsl:value-of select="substring-before(.,'photo_URL')"/>photo_URL=<xsl:value-of select="concat($xslt.base-url, 'images')"/>;photo_base=<xsl:value-of select="$xslt.base-url"/></xsl:variable>
    	<xsl:attribute name="param"><xsl:value-of select="$value"/></xsl:attribute>
    </xsl:template>

    <xsl:template match="*|@*|processing-instruction()|text()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|processing-instruction()|text()|comment()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>