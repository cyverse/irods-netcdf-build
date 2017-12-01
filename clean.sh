#!/bin/bash
#
# Usage:
#  clean.sh
#
# Removes all generated packages and intermediate artifacts from the filesystem.
#

rm --force --recursive scratch/* packages/*
