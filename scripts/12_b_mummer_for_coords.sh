#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=mumm
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID

WORKDIR='/data/users/jvaleriano/assembly_course/asm_evaluation/nucmer_comparison_2'
OUTDIR="$WORKDIR/coords"

#mkdir $OUTDIR

module load MUMmer/4.0.0rc1-GCCcore-10.3.0

#Generate coords file for flye, hifiasm and lja 
show-coords -THrd $WORKDIR/flye_vs_ref.delta > $OUTDIR/flye_coords.txt
show-coords -THrd $WORKDIR/hifiasm_vs_ref.delta > $OUTDIR/hifiasm_coords.txt
show-coords -THrd $WORKDIR/lja_vs_ref.delta > $OUTDIR/lja_coords.txt

