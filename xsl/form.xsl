<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="/">

		<select id="database">

			<xsl:for-each select="profiles/profile">

				<xsl:if test="@public='true'">
					<option>
						<xsl:attribute name="value">
							<xsl:value-of select="@name"/>
						</xsl:attribute>
						<xsl:if test="@default='true'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="description/text()"/>
					</option>
				</xsl:if>

			</xsl:for-each>

		</select>

	</xsl:template>

</xsl:stylesheet>
