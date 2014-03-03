SAXON = /usr/local/bin/saxon

.PHONY: mdata
mdata:
	$(SAXON) ../bmtnaau.mods.xml makeissues.xsl pathroot=/tmp > /tmp/bmtnaau-log.xml
