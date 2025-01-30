############
# PENDIENTE: Hacer la lista de clades para agregar colores al arbol
#############


#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=01:00:00
#SBATCH --job-name=phy_analysis
#SBATCH --partition=pibu_el8
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID


WORKDIR=/data/users/jvaleriano/assembly_course/Annotation_output/TEsorterTE

# Load modules
module load SeqKit/2.6.1
module load Clustal-Omega/1.2.4-GCC-10.3.0
module load FastTree/2.1.11-GCCcore-10.3.0

# TESorter analysis using Brassicaceae TE db as input was already done (script 19_classify_TEsorter.sh)

##ARABIDOPSIS
# Extract RT protein sequences for Gypsy Ty3-RT 
grep Ty3-RT $WORKDIR/Gypsy_arab_sequences.fa.rexdb-plant.dom.faa >$WORKDIR/arabidopsis_gypsy_list.txt
sed -i 's/>//' $WORKDIR/arabidopsis_gypsy_list.txt
sed -i 's/ .\+//' $WORKDIR/arabidopsis_gypsy_list.txt
seqkit grep -f $WORKDIR/arabidopsis_gypsy_list.txt $WORKDIR/Gypsy_arab_sequences.fa.rexdb-plant.dom.faa -o $WORKDIR/arabidopsis_Gypsy_RT.fasta

# Extract RT protein sequences for Copia Ty1-RT
grep Ty1-RT $WORKDIR/Copia_arab_sequences.fa.rexdb-plant.dom.faa > $WORKDIR/arabidopsis_copia_list.txt
sed -i 's/>//' $WORKDIR/arabidopsis_copia_list.txt
sed -i 's/ .\+//' $WORKDIR/arabidopsis_copia_list.txt
seqkit grep -f $WORKDIR/arabidopsis_copia_list.txt $WORKDIR/Copia_arab_sequences.fa.rexdb-plant.dom.faa -o $WORKDIR/arabidopsis_Copia_RT.fasta


##BRASSICACEAE
# Extract RT protein sequences for Gypsy Ty3-RT 
grep Ty3-RT $WORKDIR/Gypsy_Brassicaceae.fa.rexdb-plant.dom.faa >$WORKDIR/gypsy_list.txt
sed -i 's/>//' $WORKDIR/gypsy_list.txt
sed -i 's/ .\+//' $WORKDIR/gypsy_list.txt
seqkit grep -f $WORKDIR/gypsy_list.txt $WORKDIR/Gypsy_Brassicaceae.fa.rexdb-plant.dom.faa -o $WORKDIR/Brass_Gypsy_RT.fasta

# Extract RT protein sequences for Copia Ty1-RT
grep Ty1-RT $WORKDIR/Copia_Brassicaceae.fa.rexdb-plant.dom.faa > $WORKDIR/copia_list.txt
sed -i 's/>//' $WORKDIR/copia_list.txt
sed -i 's/ .\+//' $WORKDIR/copia_list.txt
seqkit grep -f $WORKDIR/copia_list.txt $WORKDIR/Copia_Brassicaceae.fa.rexdb-plant.dom.faa -o $WORKDIR/Brass_Copia_RT.fasta


# Concatenate Brassicaceae and Arabidopsis
cat $WORKDIR/arabidopsis_Copia_RT.fasta $WORKDIR/Brass_Copia_RT.fasta > $WORKDIR/All_Copia_RT.fasta
cat $WORKDIR/arabidopsis_Gypsy_RT.fasta $WORKDIR/Brass_Gypsy_RT.fasta > $WORKDIR/All_Gypsy_RT.fasta

# Shorten identifiers of RT sequences and replace ":" with "_"
sed -i 's/#.\+//' $WORKDIR/All_Copia_RT.fasta
sed -i 's/|.\+//' $WORKDIR/All_Copia_RT.fasta
sed -i 's/#.\+//' $WORKDIR/All_Gypsy_RT.fasta
sed -i 's/|.\+//' $WORKDIR/All_Gypsy_RT.fasta

# Align sequences with clustal Omega 
clustalo -i $WORKDIR/All_Copia_RT.fasta -o $WORKDIR/Copia_RT_aligned.fasta --outfmt=fasta --force
clustalo -i $WORKDIR/All_Gypsy_RT.fasta -o $WORKDIR/Gypsy_RT_aligned.fasta --outfmt=fasta --force

# Run FastTree
FastTree -out $WORKDIR/Copia_tree.nwk $WORKDIR/Copia_RT_aligned.fasta
FastTree -out $WORKDIR/Gypsy_tree.nwk $WORKDIR/Gypsy_RT_aligned.fasta

