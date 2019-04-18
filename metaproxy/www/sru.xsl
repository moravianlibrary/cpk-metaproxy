<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE example [
<!ENTITY databases_form SYSTEM "/www/form.html">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:srw="http://docs.oasis-open.org/ns/search-ws/sruResponse"
                xmlns:dc="http://www.loc.gov/zing/srw/dcschema/v1.0/"
                xmlns:zr="http://explain.z3950.org/dtd/2.0/"
                xmlns:diag="http://docs.oasis-open.org/ns/search-ws/diagnostic"
                xmlns:slim="http://www.loc.gov/MARC21/slim"
                xmlns:zs="http://docs.oasis-open.org/ns/search-ws/sruResponse"
                version="1.0">

  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:template match="text()"/>

  <xsl:template match="/">
    <xsl:call-template name="html"/>
  </xsl:template>

  <xsl:template name="html">
    <html>
      <head>
        <title>
          <xsl:value-of select="//zr:explain/zr:databaseInfo/zr:title"/>
        </title>
        <link type="text/css" rel="stylesheet" media="all" href="/www/style.css" />
      </head>
      <body>
        <div class="body">
          <xsl:apply-templates/>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- explain -->
  <xsl:template match="//zr:explain">
    <xsl:call-template name="dbinfo"/>
    <xsl:call-template name="diagnostic"/>
    <xsl:call-template name="searchform"/>
  </xsl:template>


  <!-- searchRetrieveResponse -->
  <xsl:template match="//srw:searchRetrieveResponse">
    <xsl:call-template name="dbinfo"/>
    <xsl:call-template name="searchform"/>
    <xsl:call-template name="diagnostic"/>
    <xsl:call-template name="displaysearch"/>
  </xsl:template>

  <xsl:template name="dbinfo">
    <div class="dbinfo">
      <h2>Vyhledávač v externích databázích</h2>
    </div>
  </xsl:template>


  <xsl:template name="searchform">
    <div class="searchForm">
      <form name="searchform" id="searchform" method="get">

        <input type="hidden" name="operation" value="searchRetrieve"/>

        <label for="database">Databáze:</label>
        &databases_form;

        <label for="query">Dotaz:</label>
        <input type="text" name="query" id="query" autofocus="true" placeholder="CQL query (example dc.title=Romeo a julie AND dc.creator=William Shakespeare)"/>

        <label for="startRecord">Od záznamu:</label>
        <input type="text" name="startRecord" id="startRecord" value="1"/>

        <label for="maximumRecords">Počet záznamů:</label>
        <input type="text" name="maximumRecords" id="maximumRecords" value="20"/>

        <label for="stylesheet">Stylesheet:</label>
        <select name="stylesheet" id="stylesheet">
          <option value="/www/sru.xsl">HTML</option>
          <option value="">XML</option>
        </select>

        <div class="submit">
          <input type="submit" value="Najdi"/>
        </div>

      </form>
    </div>

    <div class="help">
      <p>Tady bude nápověda</p>
    </div>

    <script>
    var refresh = function() {
      document.getElementById('searchform').action = document.getElementById('database').value;
    };
    refresh();
    document.getElementById('database').onchange = refresh;

    var url = new URL(window.location.href);
    var params = url.searchParams;
    ["query", "startRecord", "maximumRecords"].forEach( function(field) {
      if (params.has(field)) {
        document.getElementById(field).value = params.get(field);
      }
    });
    if (url.pathname.length > 1) {
      var database = url.pathname.slice(1);
      document.getElementById('database').value = database;
    }
    </script>

  </xsl:template>


  <!-- diagnostics -->
  <xsl:template name="diagnostic">
    <xsl:for-each select="//diag:diagnostic">
     <div class="diagnostic">
        <xsl:text> </xsl:text>
        <xsl:value-of select="diag:message"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="diag:details"/>
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="displaysearch">

    <div class="searchresults">

      <h2>
        <xsl:text>Výsledky</xsl:text>
      </h2>

      <xsl:for-each select="srw:numberOfRecords">
          <xsl:text>Počet záznamů: </xsl:text>
          <xsl:value-of select="."/>
      </xsl:for-each>

      <xsl:for-each select="srw:records">
        <table class="results">
          <tr>
            <th>Autor</th>
            <th>Název</th>
            <th>ISBN/ISSN</th>
            <th>Vydáno</th>
            <th>Vydavatel</th>
            <th>SIGLA</th>
            <th>MARC</th>
          </tr>
          <xsl:for-each select="srw:record">

            <tr>
              <td>
                <xsl:choose>
                  <xsl:when test="srw:recordData//slim:record/slim:datafield[@tag='100']/slim:subfield[@code='a']">
                    <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='100']/slim:subfield[@code='a'][1]"/>
                  </xsl:when>
                  <xsl:when test="srw:recordData//slim:record/slim:datafield[@tag='700']/slim:subfield[@code='a']">
                    <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='700']/slim:subfield[@code='a'][1]"/>
                  </xsl:when>
                </xsl:choose>
              </td>
              <td>
                <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='245']/slim:subfield[@code='a']"/>
                <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='245']/slim:subfield[@code='n']"/>
                <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='245']/slim:subfield[@code='p']"/>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="srw:recordData//slim:record/slim:datafield[@tag='020']/slim:subfield[@code='a']">
                    <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='020']/slim:subfield[@code='a'][1]"/>
                  </xsl:when>
                  <xsl:when test="srw:recordData//slim:record/slim:datafield[@tag='022']/slim:subfield[@code='a']">
                    <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='022']/slim:subfield[@code='a'][1]"/>
                  </xsl:when>
                  <xsl:when test="srw:recordData//slim:record/slim:datafield[@tag='902']/slim:subfield[@code='a']">
                    <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='902']/slim:subfield[@code='a'][1]"/>
                  </xsl:when>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="srw:recordData//slim:record/slim:datafield[@tag='264']/slim:subfield[@code='c']">
                    <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='264']/slim:subfield[@code='c'][1]"/>
                  </xsl:when>
                  <xsl:when test="srw:recordData//slim:record/slim:datafield[@tag='260']/slim:subfield[@code='c']">
                    <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='260']/slim:subfield[@code='c'][1]"/>
                  </xsl:when>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="srw:recordData//slim:record/slim:datafield[@tag='264']/slim:subfield[@code='b']">
                    <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='264']/slim:subfield[@code='b'][1]"/>
                  </xsl:when>
                  <xsl:when test="srw:recordData//slim:record/slim:datafield[@tag='260']/slim:subfield[@code='b']">
                    <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='260']/slim:subfield[@code='b'][1]"/>
                  </xsl:when>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="srw:recordData//slim:record/slim:datafield[@tag='910']/slim:subfield[@code='a']">
                    <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='910']/slim:subfield[@code='a'][1]"/>
                  </xsl:when>
                  <xsl:when test="srw:recordData//slim:record/slim:controlfield[@tag='003']">
                    <xsl:value-of select="srw:recordData//slim:record/slim:controlfield[@tag='003'][1]"/>
                  </xsl:when>
                </xsl:choose>
              </td>
              <td class="marc">
                <xsl:attribute name="id">show_details_<xsl:value-of select="zs:recordPosition"/></xsl:attribute>
                <xsl:attribute name="onclick">
                  (function() {
                    var id = "<xsl:value-of select="zs:recordPosition"/>";
                    var details = document.getElementById("record_" + id);
                    var link = document.getElementById("show_details_" + id);
                    if (details.style.display == "none") {
                      details.style.display = "";
                      link.innerHTML = "↑ (zabalit)";
                    } else {
                      details.style.display = "none";
                      link.innerHTML = "↓ (rozbalit)";
                    }
                  })();</xsl:attribute>
                <xsl:text>↓ (rozbalit)</xsl:text>
              </td>
            </tr>

            <tr style="display:none;">
              <xsl:attribute name="id">record_<xsl:value-of select="zs:recordPosition"/></xsl:attribute>
              <td colspan="7">
                <pre>
                <xsl:for-each select="srw:recordData//slim:record/slim:controlfield">
                  <xsl:value-of select="@tag"/>
                  <xsl:text>    </xsl:text>
                  <xsl:value-of select="text()"/>
                  <br/>
                </xsl:for-each>
                <xsl:for-each select="srw:recordData//slim:record/slim:datafield">
                  <xsl:value-of select="@tag"/>
                  <xsl:for-each select="slim:subfield">
                    <xsl:text> |</xsl:text>
                    <xsl:value-of select="@code"/>
                    <xsl:text> </xsl:text>
                    <xsl:choose>
                      <xsl:when test="string-length(text()) &lt;= 100">
                          <xsl:value-of select="text()"/>
                      </xsl:when>
                      <xsl:otherwise>
                          <xsl:value-of select="substring(text(), 1, 100)"/>
                          <xsl:text>...</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                  <br/>
                </xsl:for-each>
                </pre>
              </td>
            </tr>

          </xsl:for-each>
        </table>
      </xsl:for-each>

    </div>

  </xsl:template>

</xsl:stylesheet>
