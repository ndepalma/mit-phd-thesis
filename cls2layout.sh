#!/bin/bash


TEXMFDIR=`kpsewhich -var-value=TEXMFHOME`

CLS=`echo "$1" | tr "." "\n"`

for addr in $CLS
do
    if [ -v $CLSNAME ]; then
      CLSNAME=$addr
    fi
done

CLSPATH="$TEXMFDIR/tex/latex/$CLSNAME/"

echo "Installing to $CLSPATH..."

sudo mkdir -p $CLSPATH
sudo cp $1 $CLSPATH

sudo texhash --verbose

echo "Creating Lyx $CLSNAME.layout file..."
if [ -f $CLSNAME.layout ]; then
     rm $CLSNAME.layout
fi
echo "#% Do not delete the line below; configure depends on this" >> $CLSNAME.layout
echo "#  \DeclareLaTeXClass[$CLSNAME]{$CLSNAME Style}" >> $CLSNAME.layout
echo "\n"  >> $CLSNAME.layout
echo "# Read the definitions from article.layout"  >> $CLSNAME.layout
echo "Input article.layout" >> $CLSNAME.layout

mv $CLSNAME.layout ~/.lyx/layouts

lyx -batch -x reconfigure
