#! /usr/bin/env python
'''
Created on February 20, 2013
@author: cwulfman
'''

import os
import re
import argparse

cmd = 'convert'
cmd_opts = '-density 400'

def convert_images(sourcedir, targetdir):
    '''Use ImageMagick convert to create files that have uniform pixel density.'''

    for root, dirs, files in os.walk(sourcedir):
        # target_subdir = targetdir.rstrip('/') + '/' + root.lstrip('/')
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


