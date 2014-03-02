SAXON = /usr/local/bin/saxon

.PHONY: mdata
mdata:
	$(SAXON) ../bmtnaaz.mods.xml makeissues.xsl pathroot=/tmp > /tmp/bmtnaaz-log.xml
