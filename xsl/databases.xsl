<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">

		<filter xmlns="http://indexdata.com/metaproxy" type="virt_db">

			<xsl:for-each select="profiles/profile">

				<virtual route="cpk">
					<database><xsl:value-of select="@name"/></database>
				</virtual>

			</xsl:for-each>

		</filter>

	</xsl:template>

</xsl:stylesheet>
