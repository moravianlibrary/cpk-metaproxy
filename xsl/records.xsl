<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">

		<records xmlns:e="http://explain.z3950.org/dtd/2.0/">

			<xsl:for-each select="profiles/profile[@type='solr']">

				<record>
					<udb><xsl:value-of select="@name"/></udb>
					<zurl>http://localhost:8000/?profile=<xsl:value-of select="@name"/></zurl>
					<sru>solr</sru>
					<e:databaseInfo>
						<e:title lang="cz" primary="true">Centrální portál knihoven</e:title>
						<e:description lang="cz" primary="true">Centrální portál knihoven</e:description>
					</e:databaseInfo>
					<cclmap_term>s=al t=r</cclmap_term>
					<cclmap_ti>1=Title s=pw t=r</cclmap_ti>
					<cclmap_au>1=Author s=pw t=r</cclmap_au>
					<cclmap_date>1=Year</cclmap_date>
					<cclmap_id>1=PPN</cclmap_id>
					<schema name="solr"/>
				</record>

			</xsl:for-each>

		</records>

	</xsl:template>

</xsl:stylesheet>
