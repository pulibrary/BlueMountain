#! /usr/bin/env python
'''
Created on September 12, 2014
@author: cwulfman
'''

import os
import re
import argparse

xslpath = '/Users/cwulfman/BlueMountain/util/xsl/mergeviafids.xsl'
targetroot = '/tmp'

def gen_commands(sourcedir, targetdir):
    '''Generate saxon command to merge data from viaftable.xml into METS/MODS.'''
    for root, dirs, files in os.walk(sourcedir):
        target_subdir = '/'.join((targetdir.rstrip('/'),  root.lstrip('/')))
        print 'mkdir -p ' + target_subdir
        for fname in files:
            if fname.endswith('.mets.xml'):
                inpath  = '/'.join((root, fname))
                outpath = '/'.join((target_subdir, fname))
                expr    = "saxon -s:%s -xsl:%s path=%s -o:%s" % (inpath, xslpath, root, outpath)
                print expr
            if 'alto' in dirs: dirs.remove('alto')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input_dir", help="top-level directory of source tifs.")
    parser.add_argument("-o", "--output_dir", help="target directory.")
    args = parser.parse_args()

    if args.input_dir and args.output_dir:
        gen_commands(args.input_dir, args.output_dir)


