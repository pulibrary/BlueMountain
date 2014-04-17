SAXON = /usr/local/bin/saxon

.PHONY: mdata
mdata:
	$(SAXON) ../bmtnaat.mods.xml makeissues.xsl pathroot=/tmp > /tmp/bmtnaat-log.xml
