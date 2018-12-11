<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">

		<filter xmlns="http://indexdata.com/metaproxy" type="multi">

			<xsl:for-each select="profiles/profile">
				<xsl:if test="@type='z39.50'">
					<xsl:for-each select="target">
						<xsl:if test="@auth">
							<target>
								<xsl:attribute name="auth">
									<xsl:value-of select="@auth" />
								</xsl:attribute>
								<xsl:if test="../@type='z39.50' and ../@format='unimarc'">
									<xsl:attribute name="route">unimarc</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="text()"/>
							</target>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>

			<hideunavailable/>
			<hideerrors/>
		</filter>

	</xsl:template>

</xsl:stylesheet>
