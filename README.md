
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
4. **Repetitive Element Annotation**
5. **Gene Annotation**
6. **Comparative Genomics and Final Summary**

---

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
  - Trinity (if RNA assembly is required):
    ```bash
    ./07_assembly_trinity.sh
    ```

---

### Step 3: Assembly Evaluation

- Assess assembly quality using BUSCO:
  ```bash
  ./08_evaluate_asm_BUSCO.sh
  ./08_v2_evaluate_asm_BUSCO.sh
  ```

- Evaluate assemblies against the reference genome using QUAST:
  ```bash
  ./09a_evaluate_asm_ref_QUAST.sh
  ./09b_evaluate_asm_ref_QUAST.sh
  ```

---

### Step 4: Repetitive Element Annotation

- Use EDTA to annotate transposable elements:
  ```bash
  ./14_EDTA.sh
  ```

- Classify long terminal repeats (LTRs) using TEsorter:
  ```bash
  ./15_run_tesorter_LTR_classification.sh
  ```

- Visualize the LTR clades and families:
  ```r
  ./16_visualize_clades_and_fams.R
  ```

---

### Step 5: Gene Annotation

- Prepare input for MERQURY:
  ```bash
  ./10_prepare_meryl_db.sh
  ```

- Annotate using MERQURY:
  - Flye assembly:
    ```bash
    ./11a_merqury_flye.sh
    ```
  - HiFiASM assembly:
    ```bash
    ./11b_merqury_hifiasm.sh
    ```
  - LJA assembly:
    ```bash
    ./11c_merqury_lja.sh
    ```

- Run GENESPACE for comparative genomics:
  ```r
  ./32_create_Genespace_folders.R
  ./33_Genespace.R
  ./34_run_Genespace.sh
  ```

- Parse Orthofinder results:
  ```r
  ./35-19-parse_Orthofinder.R
  ```

---

### Step 6: Comparative Genomics and Final Summary

- Contextualize OMA ortholog results:
  ```python
  Contextualize_OMA.ipynb
  ```

- Summarize the overall analysis:
  ```bash
  ./Final_summary.sh
  ```

---

## Cluster Paths to Results

Key outputs from this analysis are stored in the following cluster directories:

PENDIENTE
