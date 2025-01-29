#!/bin/bash
#SBATCH --time=1-0
#SBATCH --mem=64G
#SBATCH -p pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --job-name=OMArk
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID
#SBATCH --mail-user=jazmin.valerianosaenz@students.unibe.ch
#SBATCH --mail-type=end

module load Anaconda3/2022.05
eval "$(conda shell.bash hook)"
conda activate OMArk

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/jvaleriano/assembly_course"
OUTDIR="$WORKDIR/Annotation_Evaluation/OMArk_output"

protein="$WORKDIR/Annotation_output/MAKER_out/final/assembly.all.maker.proteins.fasta.renamed.filtered.fasta"
splice="$OUTDIR/isoform_list.txt"

OMArk="/data/courses/assembly-annotation-course/CDS_annotation/softwares/OMArk-0.3.0/"

# Create output directory if it doesn't exist
mkdir -p $OUTDIR

# Prepare isoform list and save it to OUTDIR
awk '/^>/ { 
    gene = gensub(/-[A-Z]+.*/, "", "g", substr($1, 2));
    isoform = substr($1, 2);
    genes[gene] = (genes[gene] ? genes[gene] ";" : "") isoform;
} END {
    for (g in genes) print genes[g];
}' "$protein" > "$splice"

# Download OMA Database (if necessary)
# wget -P "$OUTDIR" https://omabrowser.org/All/LUCA.h5

# Run omamer search, saving output to OUTDIR
omamer search --db "LUCA.h5" --query "$protein" --out "$OUTDIR/$(basename "$protein").omamer"

# Run OMArk, saving output to OUTDIR
omark -f "$OUTDIR/$(basename "$protein").omamer" \
      -of "$protein" \
      -i "$splice" \
      -d "LUCA.h5" \
      -o "$OUTDIR"
