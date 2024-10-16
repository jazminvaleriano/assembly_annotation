#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=45G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=jellyfish
#SBATCH --partition=pibu_el8

# Set custom output and error file paths
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err    # %x is the job name, %j is the job ID

# Set the number of threads
THREADS=${SLURM_CPUS_PER_TASK}

# Directories for the input and output files
DNA_READS='/data/users/jvaleriano/assembly_course/reads/Rubezhnoe-1'
OUTDIR='/data/users/jvaleriano/assembly_course/kmer_count'

# Specify k-mer length (set to 21, but might be adjusted)
KMER_LEN=21

# Create the output directory if it doesn't exist
mkdir -p "$OUTDIR"

# Load the Jellyfish module
module load Jellyfish/2.3.0-GCC-10.3.0

# Run Jellyfish on DNA reads 
jellyfish count \
-C -m $KMER_LEN -s 5G -t $THREADS \
-o $OUTDIR/kmer_dna.jf <(zcat $DNA_READS/*fastq.gz)

# Export the kmer count histograms
jellyfish histo -t $THREADS $OUTDIR/kmer_dna.jf > $OUTDIR/kmer_dna.histo
