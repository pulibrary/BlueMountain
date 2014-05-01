SAXON = /usr/local/bin/saxon

.PHONY: mdata
mdata:
	$(SAXON) ../bmtnabd.mods.xml makeissues.xsl pathroot=/tmp > /tmp/bmtnabd-log.xml
