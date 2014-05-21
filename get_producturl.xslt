<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="xs" version="1.0">
<xsl:output omit-xml-declaration="yes" encoding="iso-8859-1" indent="no" method="text"/>

<xsl:template match="/">
    <xsl:for-each select="/Products/Product">
        <xsl:value-of select="./ProductUrl" />
        <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
