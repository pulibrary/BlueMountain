SAXON = /usr/local/bin/saxon

.PHONY: mdata
mdata:
	$(SAXON) ../bmtnabn.mods.xml makeissues.xsl pathroot=/tmp > /tmp/bmtnabn-log.xml
