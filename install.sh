#!/usr/bin/env bash

PYTHONPATH=$(pwd; )/python

PDBRC=~/.pdbrc

rm -f $PDBRC

echo "alias bs with open('$PDBRC', 'a') as pdbrc: pdbrc.write('break ' + __file__ + ':%1\n')" >> $PDBRC
echo "alias uvim  import sys;sys.path.insert(0,'$PYTHONPATH'); import debugtools as dt;dt.displayinvim(__file__)" >> $PDBRC

echo  >> $PDBRC

echo "alias n next ;; uvim" >> $PDBRC 
echo "alias c continue ;; uvim" >> $PDBRC
echo "alias s step ;; uvim" >> $PDBRC
echo "alias r run ;; uvim" >> $PDBRC

