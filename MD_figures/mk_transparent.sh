for f in *.png
do
   convert $f -transparent white ${f%.png}_transparent.png
done
