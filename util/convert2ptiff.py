#! /usr/bin/env python
'''
Created on March 9, 2013
@author: cwulfman
'''

import os
import re
import argparse

cmd = 'convert'
profile = '/'.join((os.getcwd(), 'lib', 'sRGB.icc'))
cmd_opts = ' '.join(('-density 400', '-compress lzw', '-profile', profile))

def convert_images(sourcedir, targetdir):
    '''Use ImageMagick convert to create files that have uniform pixel density.'''

    for root, dirs, files in os.walk(sourcedir):
        target_subdir = '/'.join((targetdir.rstrip('/'),  root.lstrip('/')))
        print 'mkdir -p ' + target_subdir
        for fname in files:
            if fname.endswith('.tif'):
                inpath  = '/'.join((root, fname))
                outpath = '/'.join((target_subdir, fname))
                expr = ' '.join((cmd, inpath, cmd_opts, outpath))
                print expr
        if '.svn' in dirs: dirs.remove('.svn')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input_dir", help="top-level directory of source tifs.")
    parser.add_argument("-o", "--output_dir", help="target directory.")
    args = parser.parse_args()

    if args.input_dir and args.output_dir:
        convert_images(args.input_dir, args.output_dir)


