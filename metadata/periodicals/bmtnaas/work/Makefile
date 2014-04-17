SAXON = /usr/local/bin/saxon

.PHONY: mdata
mdata:
	$(SAXON) ../bmtnaas.mods.xml makeissues.xsl pathroot=/tmp > /tmp/bmtnaas-log.xml
