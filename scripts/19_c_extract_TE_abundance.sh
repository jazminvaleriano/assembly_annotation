#!/bin/bash

# Define working directory
WORKDIR="/data/users/jvaleriano/assembly_course/Annotation_output/TEsorterTE"

# Define output file
OUTPUT_FILE="$WORKDIR/dataset_simplebar.txt"

# Path to the TE abundance summary from EDTA
EDTA_SUMMARY="/data/users/jvaleriano/assembly_course/Annotation_output/EDTA_output/flye_assembly.fasta.mod.EDTA.TEanno.sum"

# Create the header for the iTOL dataset file
echo "DATASET_SIMPLEBAR" > $OUTPUT_FILE
echo "# In simple bar charts, each ID is associated with a numeric value displayed as a bar." >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE
echo "SEPARATOR COMMA" >> $OUTPUT_FILE
echo "DATASET_LABEL,TE Abundance" >> $OUTPUT_FILE
echo "COLOR,#ff0000" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE
echo "DATA" >> $OUTPUT_FILE

# Extract TE IDs and their abundance values
awk -F"\t" '{print $1 "," $2}' $EDTA_SUMMARY >> $OUTPUT_FILE

echo "✅ Simple bar dataset created: $OUTPUT_FILE"
