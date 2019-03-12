<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:srw="http://docs.oasis-open.org/ns/search-ws/sruResponse"
                xmlns:dc="http://www.loc.gov/zing/srw/dcschema/v1.0/"
                xmlns:zr="http://explain.z3950.org/dtd/2.0/"
                xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/"
                xmlns:slim="http://www.loc.gov/MARC21/slim"
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
    <xsl:call-template name="indexinfo"/>
    <xsl:call-template name="relationinfo"/>
    <xsl:call-template name="searchform"/>
  </xsl:template>


  <!-- searchRetrieveResponse -->
  <xsl:template match="//srw:searchRetrieveResponse">
    <h2>Search Results</h2>
    <xsl:call-template name="searchform"/>
    <xsl:call-template name="diagnostic"/>
    <xsl:call-template name="displaysearch"/>
  </xsl:template>

  <!-- scanResponse -->
  <xsl:template match="//srw:scanResponse">
    <h2>Scan Results</h2>
    <xsl:call-template name="diagnostic"/>
  </xsl:template>


  <xsl:template name="dbinfo">
    <div class="dbinfo">
      <h1><xsl:value-of select="//zr:explain/zr:databaseInfo/zr:title"/>
      </h1>
      <h2><xsl:value-of select="//zr:explain/zr:databaseInfo/zr:description"/>
      </h2>
      <h4>
        <xsl:value-of select="//zr:explain/zr:databaseInfo/zr:author"/>
        <br/>
        <xsl:value-of select="//zr:explain/zr:databaseInfo/zr:history"/>
      </h4>
    </div>
  </xsl:template>


  <xsl:template name="searchform">
    <div class="searchform">
      <form name="searchform"  method="get">
        <table border="1">

        <input type="hidden" name="operation" value="searchRetrieve"/>

        <tr class="query">
          <td>
            <xsl:text>Search query: </xsl:text>
          </td>
          <td>
            <input type="text" name="query" id="query" autofocus="true"/>
          </td>
        </tr>

        <tr>
          <td>
            <xsl:text>startRecord: </xsl:text>
          </td>
          <td>
            <input type="text" name="startRecord" id="startRecord" value="1"/>
          </td>
        </tr>

        <tr>
          <td>
            <xsl:text> maximumRecords: </xsl:text>
          </td>
          <td>
            <input type="text" name="maximumRecords" id="maximumRecords" value="10"/>
          </td>
        </tr>

        <tr>
          <td>
            <xsl:text> stylesheet: </xsl:text>
          </td>
          <td>
            <select name="stylesheet" id="stylesheet">
              <option value="/www/sru.xsl">HTML</option>
              <option value="">XML</option>
            </select>
          </td>
        </tr>

        <tr>
          <td>
            <div class="submit">
              <input type="submit" value="Send Search Request"/>
            </div>
          </td>
        </tr>

        </table>
      </form>
    </div>

    <script>
    var url = new URL(window.location.href);
    var params = url.searchParams;
    ["query", "startRecord", "maximumRecords"].forEach( function(field) {
      if (params.has(field)) {
        document.getElementById(field).value = params.get(field);
      }
    });
    </script>

  </xsl:template>

  <xsl:template name="indexinfo">
     <div class="dbinfo">
       <xsl:for-each
          select="//zr:indexInfo/zr:index[zr:map/zr:name/@set]">
        <xsl:variable name="index">
          <xsl:value-of select="zr:map/zr:name/@set"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="zr:map/zr:name/text()"/>
        </xsl:variable>
        <b><xsl:value-of select="$index"/></b><br/>
      </xsl:for-each>
     </div>
  </xsl:template>


  <xsl:template name="relationinfo">
      <xsl:for-each select="//zr:configInfo/zr:supports[@type='relation']">
        <xsl:variable name="rel" select="text()"/>
        <b><xsl:value-of select="$rel"/></b><br/>
      </xsl:for-each>
  </xsl:template>


  <!-- diagnostics -->
  <xsl:template name="diagnostic">
    <xsl:for-each select="//diag:diagnostic">
     <div class="diagnostic">
        <!-- <xsl:value-of select="diag:uri"/> -->
        <xsl:text> </xsl:text>
        <xsl:value-of select="diag:message"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="diag:details"/>
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="displaysearch">

    <div class="searchresults">

      <xsl:for-each select="srw:numberOfRecords">
        <h4>
          <xsl:text>Number of Records: </xsl:text>
          <xsl:value-of select="."/>
        </h4>
      </xsl:for-each>

      <xsl:for-each select="srw:records">
        <table border="1">
          <tr>
            <th>Author</th>
            <th>Title</th>
            <th>ISBN</th>
	    <th>SIGLA</th>
	    <th>003</th>
	    <th>040</th>
          </tr>
          <xsl:for-each select="srw:record">
            <tr>
              <td>
                <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='100']/slim:subfield[@code='a']"/>
              </td>
              <td>
                <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='245']/slim:subfield[@code='a']"/>
              </td>
              <td>
                <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='020']/slim:subfield[@code='a']"/>
	      </td>
	      <td>
               <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='910']/slim:subfield[@code='a']"/>
               </td>
	       <td>
	       <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='003']"/>
               </td>
              <td>
                <xsl:value-of select="srw:recordData//slim:record/slim:datafield[@tag='040']"/>
	      </td>
 	      
            </tr>
          </xsl:for-each>
        </table>
      </xsl:for-each>

    </div>

  </xsl:template>

</xsl:stylesheet>
