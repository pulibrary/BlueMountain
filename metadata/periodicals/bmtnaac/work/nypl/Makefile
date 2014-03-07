SAXON = /usr/local/bin/saxon

.PHONY: mdata
mdata:
	$(SAXON) bmtnaac.mods.xml makeissues.xsl pathroot=/tmp > /tmp/bmtnaac-log.xml
