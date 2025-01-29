#!/bin/bash
#SBATCH --time=02:00:00
#SBATCH --mem=20G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=50
#SBATCH --job-name=filter
#SBATCH --output=./output/%x_%j.out   # %x is the job name, %j is the job ID
#SBATCH --error=./error/%x_%j.err     # %x is the job name, %j is the job ID
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jvaleriano/assembly_course/Annotation_output/MAKER_out/final"
PROTEIN_OUT="$WORKDIR/long_proteins"
TRANSCRIPT_OUT="$WORKDIR/long_transcripts"

PROTEIN_INPUT="assembly.all.maker.proteins.fasta.renamed.filtered.fasta"
PROTEIN_OUTPUT="assembly_longest_protein_isoforms.fasta"
TRANSCRIPT_INPUT="assembly.all.maker.transcripts.fasta.renamed.filtered.fasta"
TRANSCRIPT_OUTPUT="assembly_longest_transcript_isoforms.fasta"

cd "$WORKDIR"

module load SeqKit/2.6.1

# Create output directories if they don't exist
mkdir -p "$PROTEIN_OUT" "$TRANSCRIPT_OUT"

# Filter to get longest proteins
# Step 1: Extract protein lengths and store in a temporary file
seqkit fx2tab -nl "$PROTEIN_INPUT" > "$WORKDIR/protein_lengths.tsv"

# Step 2: Sort by gene ID and sequence length, then select the longest isoform per gene
sort -k1,1 -k2,2nr "$WORKDIR/protein_lengths.tsv" | \
awk '{
    gene = gensub(/-RA.*/, "", "g", $1); # Adjust regex to capture gene ID prefix only
    if (gene != last_gene) {
        print $1;
        last_gene = gene;
    }
}' > "$WORKDIR/longest_proteins.txt"

# Step 3: Use `seqkit grep` to filter the longest protein isoforms and write them to the output file
seqkit grep -f "$WORKDIR/longest_proteins.txt" "$PROTEIN_INPUT" -o "$PROTEIN_OUT/$PROTEIN_OUTPUT"


# Filter to get longest transcripts
# Step 1: Extract transcript lengths and store in a temporary file
seqkit fx2tab -nl "$TRANSCRIPT_INPUT" > "$WORKDIR/transcript_lengths.tsv"

# Step 2: Sort by gene ID and sequence length, then select the longest isoform per gene
sort -k1,1 -k2,2nr "$WORKDIR/transcript_lengths.tsv" | \
awk '{
    gene = gensub(/ .*/, "", "g", $1); # Assuming a space separates gene ID in transcripts
    if (gene != last_gene) {
        print $1;
        last_gene = gene;
    }
}' > "$WORKDIR/longest_transcripts.txt"

# Step 3: Use `seqkit grep` to filter the longest transcript isoforms and write them to the output file
seqkit grep -f "$WORKDIR/longest_transcripts.txt" "$TRANSCRIPT_INPUT" -o "$TRANSCRIPT_OUT/$TRANSCRIPT_OUTPUT"
