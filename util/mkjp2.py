'''
Created on November 30, 2011
@author: cwulfman
'''

import os
import re
import argparse

kdu_opts = '-jp2_space sRGB -rate 1,0.84,0.7,0.6,0.5,0.4,0.35,0.3,0.25,0.21,0.18,0.15,0.125,0.1,0.088,0.075,0.0625,0.05,0.04419,0.03716,0.03125,0.025,0.0221,0.01858,0.015625 Stiles=\{1024,1024\} Clevels=6 Corder=RLCP'

def convert_images(sourcedir, targetdir):
    '''Generate jp2 files.'''

    for root, dirs, files in os.walk(sourcedir):
        target_subdir = targetdir.rstrip('/') + '/' + root
        print 'mkdir -p ' + target_subdir
        for fname in files:
            if fname.endswith('.tif'):
                cmd = 'kdu_compress -i ' + root + '/' + fname
                cmd += ' -o ' +  target_subdir + '/' + fname.replace('.tif', '.jp2')
                cmd += ' ' + kdu_opts
                print cmd
        if '.svn' in dirs: dirs.remove('.svn')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input_dir", help="top-level directory of source tifs.")
    parser.add_argument("-o", "--output_dir", help="target directory.")
    args = parser.parse_args()

    if args.input_dir and args.output_dir:
        convert_images(args.input_dir, args.output_dir)


