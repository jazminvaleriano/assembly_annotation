# Set personal library path
.libPaths("/home/jvaleriano/R/x86_64-pc-linux-gnu-library/4.3/")

# Load necessary libraries
library(data.table)
library(tidyverse)

# Define file paths
annotation_file <- "/data/users/jvaleriano/assembly_course/Annotation_output/MAKER_out/final/filtered.genes.renamed.final.gff3"
scaffold_file <- "/data/users/jvaleriano/assembly_course/Annotation_output/samtools/flye_assembly.fasta.fai"
longest_proteins_file <- "/data/users/jvaleriano/assembly_course/Annotation_output/MAKER_out/final/long_proteins/assembly_longest_protein_isoforms.fasta"

# Define output file prefix
accession_name <- "Rubezhnoe-1"  # Change this to your desired prefix

# Load the annotation
annotation <- fread(annotation_file, header = FALSE, sep = "\t")
bed_genes <- annotation %>%
    filter(V3 == "gene") %>%
    select(V1, V4, V5, V9) %>%
    mutate(gene_id = as.character(str_extract(V9, "ID=[^;]*"))) %>%
    mutate(gene_id = as.character(str_replace(gene_id, "ID=", ""))) %>%
    select(-V9)

# Load and process top 20 scaffolds
top20_scaff <- fread(scaffold_file, header = FALSE, sep = "\t") %>%
    select(V1, V2) %>%
    arrange(desc(V2)) %>%
    head(20)

# Write the bed file
bed_genes <- bed_genes %>%
    filter(V1 %in% top20_scaff$V1)

gene_id <- bed_genes$gene_id
write.table(gene_id, "genespace_genes.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)

# Directory setup
if (!dir.exists("genespace")) dir.create("genespace")
if (!dir.exists("genespace/bed")) dir.create("genespace/bed")
if (!dir.exists("genespace/peptide")) dir.create("genespace/peptide")

write.table(bed_genes, paste0("genespace/bed/", accession_name, ".bed"), sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)

# Process protein sequences
system(paste("sed 's/-R.*//' ", longest_proteins_file, " > ", accession_name, "_peptide.fa", sep = ""))

system("module load MariaDB/10.6.4-GCC-10.3.0")
system("module load UCSC-Utils/448-foss-2021a")
system(paste("faSomeRecords ", accession_name, "_peptide.fa genespace_genes.txt genespace/peptide/", accession_name, ".fa", sep = ""))

# Copy additional reference files
system("cp /data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10.bed genespace/bed/")
system("cp /data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10.fa genespace/peptide/")
