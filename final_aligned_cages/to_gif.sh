convert -delay 20 -loop 0 -fuzz 10% $(cat cages_sorted_by_pore_size.txt) all_cages.gif
echo "see all_cages.gif"
