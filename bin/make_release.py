#!/usr/bin/python3

import argparse
import os

parser = argparse.ArgumentParser(description='Make release to release area')
parser.add_argument('--git-branch', '-branch', '-b', type=str, dest='branch', default='master', help='Git remote branch name. Default: master')
args = parser.parse_args()


cmd = 'git push origin {}'.format(args.branch)
print(cmd)
cmdRslt = os.system(cmd)
if cmdRslt:
    print("git push command failed. Please fix it before making a new release.")
    exit(1)
relDir = os.environ['REL_DIR']
os.chdir(relDir)
print("Go to release diretory: {}".format(relDir))

cmd = 'git pull origin {}'.format(args.branch)
print(cmd)
cmdRslt = os.system(cmd)
if cmdRslt:
    print("git pull command in release area failed. Please go to {} and fix it".format(relDir))
    exit(1)

import subprocess

def get_git_revision_hash():
    return subprocess.check_output(['git', 'rev-parse', '--short', 'HEAD']).decode('utf-8').rstrip()

print('')
print("New release successful. Release area update to version: {}".format(get_git_revision_hash()))