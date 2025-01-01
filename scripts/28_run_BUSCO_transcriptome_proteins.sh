#!/bin/bash
#SBATCH --time=10-0
#SBATCH --mem=100G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=50
#SBATCH --job-name=BUSCO
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID
#SBATCH --partition=pibu_el8

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/jvaleriano/assembly_course"
OUTDIR="$WORKDIR/Annotation_Evaluation/BUSCO_output"
protein="$WORKDIR/Annotation_output/MAKER_out/final/long_proteins/assembly_longest_protein_isoforms.fasta"
transcript="$WORKDIR/Annotation_output/MAKER_out/final/long_transcripts/assembly_longest_transcript_isoforms.fasta"

module load BUSCO/5.4.2-foss-2021a

mkdir -p $OUTDIR
cd $OUTDIR

busco \
    -i $transcript \
    -l brassicales_odb10 \
    -o Maker_transcripts \
    -m transcriptome \
    --cpu 50 \
    --out_path $OUTDIR \
    --download_path $OUTDIR \
    --force


busco \
    -i $protein \
    -l brassicales_odb10 \
    -o Maker_proteins \
    -m proteins \
    --cpu 50 \
    --out_path $OUTDIR \
    --download_path $OUTDIR \
    --force

