#!/usr/bin/python
#-*-coding: utf-8-*-
"""
Utility for generating generative jp2s for Blue Mountain.

Adapted from code by Jon Stroop.

For safety, this should be run be a user that has read-only access to the source
file system (i.e., source TIFFs).
"""
import os
import logging
import subprocess
from datetime import datetime
################################################################################
## Common options - Set these ##################################################
###############################################################################
# Generic location in the pudl file system - e.g., pudl0001 or pudl0001/4609321 
# DO NOT include a leading slash, e.g., "/pudl0001".
PUDL_LOCATORS = [
    "pudl0097"
]
#
EXTRACT_LEVELS = False #TODO: not implemented
#
# True if we want to replace existing files, otherwise False
OVERWRITE_EXISTING = False
################################################################################
## Less Common Options #########################################################
###############################################################################
# Location of source images. "pudlXXXX" directories should be directly inside.
# SOURCE_ROOT = "/Volumes/DPSA_SanVol1/derivative_processing"
SOURCE_ROOT = "/tmp/deriv/in"
#
# Location of target images. "pudlXXXX" directories and subdirectories will be
# created.  
# TARGET_ROOT = "/Volumes/DPSA_SanVol1/derivative_processing/out"
TARGET_ROOT = "/tmp/deriv/out"
#
# Location for temporary half-size TIFFs, required for setting color profile.
TMP_DIR = "/tmp"
#
# Recipes for Image Magick and Kakadu.
TWENTY_FOUR_BIT_IMAGEMAGICK_OPTS = " -quality 100 -profile \"" + os.getcwd() + "/lib/sRGB.icc\""
TWENTY_FOUR_BIT_KDU_RECIPE = "\
-rate -,1,0.5.0.25 Clevels=5 Clayers=5 Cuse_precincts=yes Cprecincts=\{256,256\} Cblk=\{64,64\} Corder=RPCL ORGgen_plt=yes ORGtparts=R Stiles=\{256,256\} \
-jp2_space sRGB \
-double_buffering 10 \
-num_threads 4 \
-no_weights \
-quiet"

EIGHT_BIT_IMAGEMAGICK_OPTS = "-colorspace Gray -quality 100 -resize 3600x3600"
EIGHT_BIT_KDU_RECIPE = "\
-rate 0.80 Clevels=5 Clayers=5 Cuse_precincts=yes Cprecincts=\{256,256\} Cblk=\{64,64\} Corder=RPCL ORGgen_plt=yes ORGtparts=R Stiles=\{256,256\} \
-double_buffering 10 \
-num_threads 4 \
-no_weights \
-quiet"

EXIV2_GET_BPS = "-Pt -g Exif.Image.BitsPerSample print"

# Installations may need to adjust these
EXIV2 = "/opt/local/bin/exiv2"
CONVERT = "/usr/local/bin/convert"

################################################################################
# Code. Leave this alone :). ###################################################
################################################################################

LIB = os.getcwd() + "/lib"
ENV = {"LD_LIBRARY_PATH":LIB, "PATH":LIB + ":$PATH"}
TWENTY_FOUR_BITS = "8 8 8"
EIGHT_BITS = "8"

# Logging
log = logging.getLogger("DerivativeMaker")
log.setLevel(logging.DEBUG)


format = '%(asctime)s %(levelname)-5s: %(message)s'
dateFormat = '%Y-%m-%dT%H:%M:%S'
formatter = logging.Formatter(format, dateFormat)

now = datetime.now()
logdir = "logs/" + now.strftime("%Y/%m/%d/")
if not os.path.exists(logdir): os.makedirs(logdir)

time = now.strftime("%H:%M:%S")

# OUT
outFilePath = logdir + time + "-out.log"
out = logging.FileHandler(outFilePath)
out.setLevel(logging.INFO)
out.setFormatter(formatter)
log.addHandler(out)

# ERR
errFilePath = logdir + time + "-err.log"
err = logging.FileHandler(errFilePath)
err.setLevel(logging.ERROR)
err.setFormatter(formatter)
log.addHandler(err)

class DerivativeMaker(object):
        def __init__(self):
            self.__files = []
        
        @staticmethod
        def _dirFilter(dir_name):
            return not dir_name.startswith(".")
        
        @staticmethod
        def _tiffFilter(file_name):
            return file_name.endswith(".tif") and not file_name.startswith(".")
        
        @staticmethod
        def _changeExtension(oldPath, newExtenstion):
            """
            Given a path with an image at the end (e.g., foo/bar/00000007.tif)
            and a new extension (e.g. ".jpg") returns the path with the new 
            extension (e.g., foo/bar/00000007.jpg
            """
            lastStop = oldPath.rfind(".")
            return oldPath[0:lastStop] + newExtenstion
        
        def buildFileList(self):
            for l in PUDL_LOCATORS:
                self._buildFileList(locator=l)
        
        def _buildFileList(self, locator=None, dir=None):
            if dir == None: 
                dir = os.path.join(SOURCE_ROOT, locator)
            
            for node in os.listdir(dir):
                absPath = os.path.join(dir, node)
                
                if os.path.isdir(absPath) and DerivativeMaker._dirFilter(node):
                     self._buildFileList(dir=absPath) #recursive call
                elif os.path.isfile(absPath) and DerivativeMaker._tiffFilter(node):
                    self.__files.append(absPath)
                else:
                    pass
                        
        def makeDerivs(self):
            self.__files.sort()
            for tiffPath in self.__files:
                
                bps = DerivativeMaker._getBitsPerSample(tiffPath)
                
                outTmpTiffPath = TMP_DIR + tiffPath[len(SOURCE_ROOT):]

                outJp2WrongExt = TARGET_ROOT + outTmpTiffPath[len(TMP_DIR):]
                outJp2Path = DerivativeMaker._changeExtension(outJp2WrongExt, ".jp2")

                if not os.path.exists(outJp2Path) or OVERWRITE_EXISTING == True: 
                    tiffSuccess = DerivativeMaker._makeTmpTiff(tiffPath, outTmpTiffPath, bps)
                    if tiffSuccess:
                        DerivativeMaker._makeJp2(outTmpTiffPath, outJp2Path, bps)
                        os.remove(outTmpTiffPath)
                        log.debug("Removed temporary file: " + outTmpTiffPath)
                    else:
                        os.remove(outTmpTiffPath)	 
                else:
                    log.warn("File exists: " + outJp2Path)

        @staticmethod
        def _makeTmpTiff(inPath, outPath, inBitsPerSample):
            '''
            Returns the path to the TIFF that was created.
            '''
            #TODO: untested
            newDirPath = os.path.dirname(outPath)
            if not os.path.exists(newDirPath): os.makedirs(newDirPath, 0755)
            
            cmd = CONVERT + " " + inPath  
            if inBitsPerSample == TWENTY_FOUR_BITS:
                cmd = cmd + " " + TWENTY_FOUR_BIT_IMAGEMAGICK_OPTS
            elif inBitsPerSample == EIGHT_BITS:
                cmd = cmd + " " + EIGHT_BIT_IMAGEMAGICK_OPTS
            else:
                log.error("Could not get bits per sample: " + outPath)
                return False
            cmd = cmd + " " + outPath

            proc = subprocess.Popen(cmd, shell=True, \
                stderr=subprocess.PIPE, stdout=subprocess.PIPE)
            return_code = proc.wait()
            
            # Read from pipes
            for line in proc.stdout:
                log.info(line.rstrip())
            for line in proc.stderr:
                log.error(line.rstrip() + " (" + outPath + ")") 
                                
            if os.path.exists(outPath) and os.path.getsize(outPath) != 0:
                log.debug("Created temporary file: " + outPath)
                return True
            else:
                if os.path.exists(outPath): os.remove(outPath)
                log.error("Failed to create temporary file: " + outPath)
                return False

        @staticmethod
        def _makeJp2(inPath, outPath, inBitsPerSample):
            '''
            Returns the path to the TIFF that was created.
            '''
            #TODO: untested
            newDirPath = os.path.dirname(outPath)
            if not os.path.exists(newDirPath): os.makedirs(newDirPath, 0755)
            
            cmd = "kdu_compress -i " + inPath + " -o " + outPath 
            if inBitsPerSample == TWENTY_FOUR_BITS:
                cmd = cmd + " " + TWENTY_FOUR_BIT_KDU_RECIPE
            elif inBitsPerSample == EIGHT_BITS:
                cmd = cmd + " " + EIGHT_BIT_KDU_RECIPE
            else:
                log.error("Could not get bits per sample: " + outPath)
                return False
            
            proc = subprocess.Popen(cmd, shell=True, env=ENV, \
                    stderr=subprocess.PIPE, stdout=subprocess.PIPE)
            return_code = proc.wait()
            
            # Read from pipes
            for line in proc.stdout:
                log.info(line.rstrip())
                
            for line in proc.stderr:
                log.error(line.rstrip() + " (" + outPath + ")") 
                
            if os.path.exists(outPath) and os.path.getsize(outPath) != 0:
                log.info("Created: " + outPath)
                os.chmod(outPath, 0644)
                return True
            else:
                if os.path.exists(outPath): os.remove(outPath)
                log.error("Failed to create: " + outPath)
                return False
            
        @staticmethod
        def _getBitsPerSample(inPath):
            cmd = EXIV2 + " " + EXIV2_GET_BPS + " " + inPath
            
            proc = subprocess.Popen(cmd, shell=True, env=ENV, \
                    stderr=subprocess.PIPE, stdout=subprocess.PIPE)
            return_code = proc.wait()
            
            # Read from pipes
            response = None
            for line in proc.stdout:
                if response == None:
                    response = line.rstrip()
            for line in proc.stderr:
                log.error(line.rstrip() + " (" + inPath + ")") 
                
            return response
        
if __name__ == "__main__":
    
    dMaker = DerivativeMaker()
    dMaker.buildFileList()
    dMaker.makeDerivs()
    for handler in  logging.getLogger("DerivativeMaker").handlers:
        path = handler.baseFilename
        if os.path.getsize(path) == 0:
            os.remove(path)
            os.sys.stdout.write("Removed empty log: " + path + "\n")

