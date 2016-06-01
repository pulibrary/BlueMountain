#! /usr/bin/env python
# apply_struct_fix.py
'''
Created on May 18, 2016
@author: cwulfman
'''

import os
import re
import argparse

xslpath = '/Users/cwulfman/BlueMountain/util/xsl/StructFix.xsl'
targetroot = '/tmp'

def gen_commands(sourcedir, targetdir):
    '''Generate saxon command to apply Jennifer Goslee's illustration structure fix to a tree of METS files.'''
    for root, dirs, files in os.walk(sourcedir):
        target_subdir = '/'.join((targetdir.rstrip('/'),  root.lstrip('/')))
        print 'mkdir -p ' + target_subdir
        for fname in files:
            if fname.endswith('.mets.xml'):
                inpath  = '/'.join((root, fname))
                outpath = '/'.join((target_subdir, fname))
                expr    = "saxon -s:%s -xsl:%s path=%s -o:%s" % (inpath, xslpath, root, outpath)
                print "echo 'transforming %s'" % inpath
                print expr
                print "echo 'wrote %s'" % outpath
            if 'alto' in dirs: dirs.remove('alto')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input_dir", help="top-level directory of source tifs.")
    parser.add_argument("-o", "--output_dir", help="target directory.")
    args = parser.parse_args()

    if args.input_dir and args.output_dir:
        gen_commands(args.input_dir, args.output_dir)


