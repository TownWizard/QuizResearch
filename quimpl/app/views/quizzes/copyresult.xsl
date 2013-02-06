<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:param name="client_stylesheet" />

    <xsl:template match="/">
        <xsl:processing-instruction name="xml-stylesheet">
            href="/stylesheets/<xsl:value-of select='$client_stylesheet'/>" type="text/xsl"
        </xsl:processing-instruction>
        <xsl:copy-of select="." />
    </xsl:template>

</xsl:stylesheet>
