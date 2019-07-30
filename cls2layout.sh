#!/bin/bash

set -e

TEXMFDIR=`kpsewhich -var-value=TEXMFHOME`
CLSNAME=`basename $1 .cls`
CLSPATH="$TEXMFDIR/tex/latex/$CLSNAME/"

echo "Installing to $CLSPATH..."

mkdir -p $CLSPATH
cp $1 $CLSPATH

texhash --verbose

echo "Creating Lyx $CLSNAME.layout file..."
if [ -f $CLSNAME.layout ]; then
     rm $CLSNAME.layout
fi
echo "#% Do not delete the line below; configure depends on this" >> $CLSNAME.layout
echo "#  \DeclareLaTeXClass[$CLSNAME]{$CLSNAME Style}" >> $CLSNAME.layout
echo -e "\n"  >> $CLSNAME.layout
echo "# Read the definitions from book.layout"  >> $CLSNAME.layout
echo "Input book.layout" >> $CLSNAME.layout

mv $CLSNAME.layout "$2/layouts"

lyx -batch dummy -x reconfigure 

