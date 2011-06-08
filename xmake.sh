#!/bin/bash

echo -e "\n\n\n\n\n\n" 
echo "________________________________________________________________________"
echo -e "\n\n\n\n\n\n"

make $@ 2>&1 | perl colorize.pl 2>&1 | perl gSTLFilt.pl -width:120
