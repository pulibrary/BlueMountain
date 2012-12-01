jp2s := $(patsubst %.tif, %.jp2, $(wildcard *.tif))
jpgs := $(patsubst %.tif, %.jpg, $(wildcard *.tif))


jp2files : $(jp2s)
jpgfiles : $(jpgs)

%.jp2 : %.tif
	kdu_compress -i $< -o $@  -jp2_space sRGB -rate 1,0.84,0.7,0.6,0.5,0.4,0.35,0.3,0.25,0.21,0.18,0.15,0.125,0.1,0.088,0.075,0.0625,0.05,0.04419,0.03716,0.03125,0.025,0.0221,0.01858,0.015625 Stiles=\{1024,1024\} Clevels=6 Corder=RLCP

%.jpg : %.tif
	gm convert -scale 25% -quality 70% -colorspace sRGB $< $@


.PHONY: clean
clean:
	rm *.jp2 *.jpg
