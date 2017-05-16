<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:marc="http://www.loc.gov/MARC21/slim">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

	<xsl:template match="text()"/>

        <xsl:template match="marc:collection">
                <xsl:apply-templates/>
        </xsl:template>

	<xsl:template match="marc:record">
		<marc:record>
			<xsl:copy-of select="*"/>
		</marc:record>
        </xsl:template>

</xsl:stylesheet>
