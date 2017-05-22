<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">

		<filter xmlns="http://indexdata.com/metaproxy" type="virt_db">

			<xsl:for-each select="profiles/profile">

				<virtual>
					<xsl:if test="@type='solr'">
						<xsl:attribute name="route">cpk</xsl:attribute>
					</xsl:if>
					<database><xsl:value-of select="@name"/></database>
					<xsl:if test="@type='z39.50'">
						<xsl:for-each select="target">
							<target><xsl:value-of select="text()"/></target>
						</xsl:for-each>
					</xsl:if>
				</virtual>

			</xsl:for-each>

		</filter>

	</xsl:template>

</xsl:stylesheet>
