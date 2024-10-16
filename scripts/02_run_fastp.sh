#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fastp
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err    # %x is the job name, %j is the job ID

DNADIR='/data/users/jvaleriano/assembly_course/reads/Rubezhnoe-1'
RNADIR='/data/users/jvaleriano/assembly_course/reads/RNAseq_Sha'
OUTDIR='/data/users/jvaleriano/assembly_course/read_QC/fastp'

# Create the output directory if it doesn't exist
echo "Creating output directory at $OUTDIR"
mkdir -p "$OUTDIR"

# Load FASTP
module load fastp/0.23.4-GCC-10.3.0

# Run fastp on RNAseq data (paired-end reads)
fastp -i $RNADIR/*_1.fastq.gz -I $RNADIR/*_2.fastq.gz -o $OUTDIR/rna_R1_trimmed.fastq -O $OUTDIR/rna_R2_trimmed.fastq -h $OUTDIR/fastp_report_rna.html -j $OUTDIR/fastp_report_rna.json

# Run fastp on DNAseq data (single-end reads, without filtering)
fastp --disable_adapter_trimming --disable_quality_filtering --disable_length_filtering \
      -i $DNADIR/*.fastq.gz \
      -o $OUTDIR/dna_output.fastq \
      -h $OUTDIR/dna_fastp_report.html \