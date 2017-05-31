<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:output indent="yes" method="text" version="1.0" encoding="UTF-8"/>

	<xsl:template name="replace-string">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="with"/>
		<xsl:choose>
			<xsl:when test="contains($text,$replace)">
				<xsl:value-of select="substring-before($text,$replace)"/>
				<xsl:value-of select="$with"/>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="substring-after($text,$replace)"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="with" select="$with"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="text()"/>

	<xsl:template match="doc">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="str[@name='fullrecord']">
		<xsl:call-template name="replace-string">
			<xsl:with-param name="text" select="text()"/>
			<xsl:with-param name="replace" select="'&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;'" />
			<xsl:with-param name="with" select="''"/>
		</xsl:call-template>
        </xsl:template>

</xsl:stylesheet>
