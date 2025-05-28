#!/bin/sh
imgpath="$HOME/images/imagemagick/converter/images"
inputpath="$HOME/images/imagemagick/converter/inputs"
outputpath="$HOME/images/imagemagick/converter/outputs"
maskpath="$outputpath/mask.png"
temppath="$HOME/images/imagemagick/converter/temp"

mkdir -p "$inputpath" "$outputpath" "$temppath"

i=1
for file in "$outputpath"/*; do
	renamed="$temppath/output$i.png"
	mv "$file" "$renamed"
	i=$((i + 1))
done

i=1
for file in "$temppath"/*; do
	mv "$file" "$outputpath/output$i.png"
	i=$((i + 1))
done

rm -rf "$temppath"

for file in "$imgpath"/*; do
	cp "$file" "$inputpath/input$i.png"
	w=$(identify -format "%w" "$inputpath/input$i.png")
	h=$(identify -format "%h" "$inputpath/input$i.png")
	convert -size "${w}x${h}" gradient:white-black -sigmoidal-contrast 10x25% "$maskpath"
	convert "$inputpath/input$i.png" \
		\( "$maskpath" -gravity south -crop 100%x100%+0+0 +repage \) \
		-gravity south -compose CopyOpacity -composite \
		"$outputpath/output$i.png"
	rm -f "$maskpath"
	i=$((i + 1))
done
rm -f $inputpath/*
#rm -f $imgpath/* clear imgpath
#crop image command convert x.png -crop 100%x55%+0+920 y.png
