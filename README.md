
# Genome Assembly and Annotation of an Accession of *Arabidopsis thaliana*

This project involved the genome assembly and annotation of a single accession of *Arabidopsis thaliana*, aiming to assess assembly quality of different assemblying tools, identify genomic features, and annotate repetitive elements and gene content.
Sequencing data from Q. Lian et al. ([DOI: 10.1038/s41588-024-01715-9](https://doi.org/10.1038/s41588-024-01715-9)).

This repository is part of the final project for the course **473637-HS2024-0 Genome and Transcriptome Assembly** at the University of Bern.

---

## Analysis Pipeline

The analysis pipeline consists of the follwing steps:

1. **Preparation and Quality Control of Input Data**
2. **Genome Assembly**
3. **Assembly Evaluation**
4. **Repetitive Element (Transposable Elements) Annotation and Classification**
5. **Phylogenetic Analysis of TEs**
6. **Gene Annotation**
7. **Comparative Genomics**

---
All .sh scripts were executed on the IBU cluster using the SLURM workload manager (sbatch). 

R scripts were executed locally. 

### Step 1: Preparation and Quality Control of Input Data

- **Download Reads:** Retrieve the sequencing data.
  ```bash
  ./00_download_reads.sh
  ```

- **Quality Control:**
  - DNA FastQC analysis:
    ```bash
    ./01_run_dna_FASTQC_module.sh
    ```
  - RNA FastQC analysis:
    ```bash
    ./01_run_rna_FASTQC_module.sh
    ```
  - General FASTP quality control:
    ```bash
    ./02_run_fastp.sh
    ```

- **Count K-mers for preliminary analysis:**
  ```bash
  ./03_count_kmers_jellyfish.sh
  ```

---

### Step 2: Genome Assembly

- Assemble using multiple tools for comparison:
  - Flye:
    ```bash
    ./04_assemble_flye.sh
    ```
  - HiFiASM:
    ```bash
    ./05_assembly_hifiasm.sh
    ```
  - LJA:
    ```bash
    ./06_assembly_LJA.sh
    ```
  - Trinity (for RNA assembly):
    ```bash
    ./07_assembly_trinity.sh
    ```

---

### Step 3: Assembly Evaluation

- Assess assembly single-copy ortholog completeness using BUSCO:
  ```bash
  ./08_evaluate_asm_BUSCO.sh
  ```

- Calculate key assembly metrics using QUAST (with and without reference genome):
  ```bash
  ./09a_evaluate_asm_nref_QUAST.sh
  ./09b_evaluate_asm_ref_QUAST.sh
  ```
- Evaluate the consensus quality value (QV) and validate k-mer spectrum completeness using Merqury:
    ```bash
  ./10_prepare_meryl_db.sh  
  ./11a_merqury_flye.sh #Run for each assembly
  ```
- Create dotplots to compare assemblies to reference and to each other:
  ```bash
  .12_run_mummer.sh  
  ```
- Extract coords files for analysis of missalignments:
  ```bash
  ./12_b_mummer_for_coords.sh
---

### Step 4: Repetitive Element Annotation

- Use EDTA to annotate transposable elements:
  ```bash
  ./13_run_EDTA.sh
  ```

- Classify long terminal repeats (LTRs) using TEsorter:
  ```bash
  ./14_a_run_tesorter_LTR_classification.sh
  ```

- Visualize the LTR clades and families:
  ```bash
  ./14_b_visualize_clades_and_fams.R
  ```
- Index assembled genome to obtain scaffold lengths, and process annotations in R:
    ```bash
  ./15_a_generate_faidx_samtools.sh
  ./15_b_visualize_annotations.R
  ```
---
### Step 5: TEs Age Estimation and Phylogenetic Analysis
- Classify TEs specific to A. thaliana and Brassicaceae and analyze with SeqKit:
  ```bash
  16_classify_TE_TEsorter.sh
  ```
- Parse RepeatMasker output (from EDTA) to estimate divergence from consensus sequence:
  ```bash
  17_estimate_insertion_age.sh
  18_plot_divergence.R
  ```
- Phylogenetic Analysis using SeqKit, Clustal Omega and FastTree:
  ```bash
  19_a_phylogenetic_analysis.sh
  ```
- Optionally, use the following scripts to generate datasets to add features to the trees on iTol:
  ```bash
  19_b_add_colors_to_abundance.sh
  19_c_extract_TE_abundance.sh
  ```
---

### Step 6: Gene Annotation
- Annotate genes using MAKER pipeline:
  ```bash
  20_a_create_maker_CTLfile.sh
  20_b_run_maker.sh
  20_c_prepare_maker_output.sh
  ```
- Validate completeness using BUSCO:
  ```bash
  21_get_longest_prot_transcripts.sh
  22_run_BUSCO_transcriptome_proteins.sh
  ```
- Run BLAST to confirm protein homology:
  ```bash
  23_run_BLAST.sh
  ```
- Orthology based gene annotation quality control using OMArk:
  ```bash
  24_a_create_OMArk_env.sh
  24_b_run_OMArk_QC.SH
  ```

### Step 7: Comparative Genomics and Final Summary

- Run GENESPACE for comparative genomics:
  ```bash
  ./25_create_Genespace_folders.R
  ./26_Genespace.R
  ./27_run_Genespace.sh
  ```

- Parse Orthofinder results:
  ```bash
  ./28-parse_Orthofinder.R
  ```

---

- Contextualize OMA ortholog results:
  ```bash
  Contextualize_OMA.ipynb
  ```

- Summarize the overall analysis:
  ```bash
  ./Final_summary.sh
  ```

---


