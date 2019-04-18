#!/bin/bash
xsltproc xsl/records.xsl profiles.xml > metaproxy/records.xml
xsltproc xsl/databases.xsl profiles.xml > metaproxy/databases.xml
xsltproc xsl/multi.xsl profiles.xml > metaproxy/multi.xml
xsltproc xsl/form.xsl profiles.xml > metaproxy/www/form.html
metaproxy --config metaproxy.xml -w metaproxy/ & php -S localhost:8000 www/router.php
