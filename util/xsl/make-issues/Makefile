SAXON = /usr/local/bin/saxon

.PHONY: mdata
mdata:
	$(SAXON) ../bmtnaan.mods.xml makeissues.xsl pathroot=/tmp > /tmp/bmtnaan-log.xml
