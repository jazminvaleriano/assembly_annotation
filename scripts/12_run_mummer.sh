#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=nucmer
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID

# Directories for the input and output files
OUTDIR='/data/users/jvaleriano/assembly_course/asm_evaluation/nucmer_comparison_3'
ASM_FLYE='/data/users/jvaleriano/assembly_course/assemblies/flye/flye_assembly.fasta'
ASM_HIFIASM='/data/users/jvaleriano/assembly_course/assemblies/hifiasm/hifiasm.fa'
ASM_LJA='/data/users/jvaleriano/assembly_course/assemblies/lja/lja_assembly.fasta'
REFDIR='/data/courses/assembly-annotation-course/references' 
REF_GENOME="$REFDIR/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"  # Reference genome

# Create output directory
mkdir -p $OUTDIR

# Run nucmer for Flye assembly
apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
nucmer --maxmatch --prefix=$OUTDIR/flye_vs_ref --breaklen 2000 --mincluster 3000 $REF_GENOME $ASM_FLYE

# Run nucmer for Hifiasm assembly
apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
nucmer --maxmatch --prefix=$OUTDIR/hifiasm_vs_ref --breaklen 2000 --mincluster 3000 $REF_GENOME $ASM_HIFIASM

# Run nucmer for LJA assembly
apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
nucmer --maxmatch --prefix=$OUTDIR/lja_vs_ref --breaklen 2000 --mincluster 3000 $REF_GENOME $ASM_LJA

# Generate dotplot for Flye assembly
apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
mummerplot --png --layout --prefix=$OUTDIR/flye_vs_ref --filter $OUTDIR/flye_vs_ref.delta

# Generate dotplot for Hifiasm assembly
apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
mummerplot --png --layout --prefix=$OUTDIR/hifiasm_vs_ref --filter $OUTDIR/hifiasm_vs_ref.delta

# Generate dotplot for LJA assembly
apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
mummerplot --png --layout --prefix=$OUTDIR/lja_vs_ref --filter $OUTDIR/lja_vs_ref.delta

# Compare Flye, Hifiasm, and LJA assemblies with each other
# Flye vs Hifiasm
#apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
#nucmer --prefix=$OUTDIR/flye_vs_hifiasm --breaklen 2000 --mincluster 3000 $ASM_FLYE $ASM_HIFIASM

# Flye vs LJA
#apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
#nucmer --prefix=$OUTDIR/flye_vs_lja --breaklen 2000 --mincluster 3000 $ASM_FLYE $ASM_LJA

# Hifiasm vs LJA
#apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
#nucmer --prefix=$OUTDIR/hifiasm_vs_lja --breaklen 2000 --mincluster 3000 $ASM_HIFIASM $ASM_LJA

# Generate dotplot for Flye vs Hifiasm
#apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
#mummerplot --png --layout --prefix=$OUTDIR/flye_vs_hifiasm --filter $OUTDIR/flye_vs_hifiasm.delta

# Generate dotplot for Flye vs LJA
#apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
#mummerplot --png --layout --prefix=$OUTDIR/flye_vs_lja --filter $OUTDIR/flye_vs_lja.delta

# Generate dotplot for Hifiasm vs LJA
#apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
#mummerplot --png --layout --prefix=$OUTDIR/hifiasm_vs_lja --filter $OUTDIR/hifiasm_vs_lja.delta
