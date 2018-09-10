finalfolder="final_submission"
mainfile="SI"
 # mainfile="latent_space_of_cages"
cp ../all_cages/latex_code_for_viz.tex $finalfolder/

mkdir $finalfolder

 # mkdir JACS_submission
# get fig list
grep "File:" ${mainfile}.log | grep ".pn" | awk '{print $2}' > listoffigs.txt
grep "File:" ${mainfile}.log | grep ".pdf" | awk '{print $2}' >> listoffigs.txt
grep "File:" ${mainfile}.log | grep ".jpg" | awk '{print $2}' >> listoffigs.txt
grep "File:" ${mainfile}.log | grep ".jpeg" | awk '{print $2}' >> listoffigs.txt

cp ${mainfile}.tex temp.tex
onlyname=( $(awk -F"/" '{print $NF}' listoffigs.txt) )
figs=( $(cat listoffigs.txt) )
n=$(cat listoffigs.txt | wc -l)

for ((i=0; i<$n; i++))
do
    fig=${figs[i]}
    cp $fig ./$finalfolder
    name=${onlyname[i]}
    sed -i s/${fig//\//\\/}/${onlyname[i]}/ temp.tex 
done

mv temp.tex ${finalfolder}/${mainfile}.tex
cp bibfile.bib ${finalfolder}
