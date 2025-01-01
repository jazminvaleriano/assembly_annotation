#!/bin/bash

# Input files
RAW_GENE_GFF="/data/users/jvaleriano/assembly_course/Annotation_output/MAKER_out/assembly.all.maker.noseq.gff"
MAKER_GFF="/data/users/jvaleriano/assembly_course/Annotation_output/MAKER_out/final/filtered.genes.renamed.final.gff3"
BLAST_GFF="/data/users/jvaleriano/assembly_course/Annotation_Evaluation/BLAST_output/filtered.genes.renamed.final.gff3.Uniprot.gff3"
OMARK_OUTPUT="/data/users/jvaleriano/assembly_course/Annotation_Evaluation/OMArk_output/assembly.all.maker.proteins.fasta.renamed.filtered.fasta.omamer"

# Output summary file
SUMMARY_FILE="/data/users/jvaleriano/assembly_course/Annotation_output/genome_annotation_summary.txt"

# Initialize summary file
echo "Genome Annotation Summary" > $SUMMARY_FILE
echo "=========================" >> $SUMMARY_FILE
echo "" >> $SUMMARY_FILE

# 1. Number of Genes (from raw GFF file)
raw_num_genes=$(grep -c -w "gene" $RAW_GENE_GFF)
echo "Number of Genes (Raw): $raw_num_genes" >> $SUMMARY_FILE

# 2. Number of Filtered Genes (from final GFF file)
filtered_num_genes=$(grep -c -w "gene" $MAKER_GFF)
echo "Number of Filtered Genes: $filtered_num_genes" >> $SUMMARY_FILE

# 3. Genes with meaningful BLAST hits (excluding "Protein of unknown function")
genes_with_blast=$(grep -P '\tgene\t' $BLAST_GFF | grep -v "Protein of unknown function" | wc -l)
echo "Genes with BLAST Hits: $genes_with_blast" >> $SUMMARY_FILE

# 4. Genes without BLAST Hits
genes_without_blast=$((filtered_num_genes - genes_with_blast))
echo "Genes without BLAST Hits: $genes_without_blast" >> $SUMMARY_FILE

# 5. Genes in Core Orthogroups

# 6. Genes in Accession-Specific Orthogroups
