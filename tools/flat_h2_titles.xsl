<?xml version="1.0"?>
<!-- Thanks to Dimitre Novatchev: https://stackoverflow.com/questions/
5219330/using-xslt-1-0-to-wrap-sibling-elements-of-a-header -->
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output omit-xml-declaration="yes" indent="yes"/>
 <xsl:strip-space elements="*"/>

 <xsl:key name="kFollowing" match="node()[not(self::h2)]"
  use="generate-id(preceding-sibling::h2[1])"/>

 <xsl:template match="node()|@*" name="identity">
     <xsl:copy>
       <xsl:apply-templates select="node()|@*"/>
     </xsl:copy>
 </xsl:template>

 <xsl:template match="h2">
  <div>
   <xsl:call-template name="identity"/>
   <xsl:apply-templates mode="copy"
       select="key('kFollowing', generate-id())"/>
  </div>
 </xsl:template>

 <xsl:template match="node()[not(self::h2)][preceding-sibling::h2]"/>

 <xsl:template match="node()" mode="copy">
  <xsl:call-template name="identity"/>
 </xsl:template>
</xsl:stylesheet>
