#!/bin/bash

# Define working directory
WORKDIR="/data/users/jvaleriano/assembly_course/Annotation_output/TEsorterTE"

# Define input file (Repeat Stats section)
INPUT_FILE="$WORKDIR/dataset_simplebar.txt"

# Define output file for iTOL
OUTPUT_FILE="$WORKDIR/dataset_simplebar_colored.txt"

# Create the iTOL header
echo "DATASET_SIMPLEBAR" > $OUTPUT_FILE
echo "# In simple bar charts, each ID is associated with a numeric value displayed as a bar." >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE
echo "SEPARATOR COMMA" >> $OUTPUT_FILE
echo "DATASET_LABEL,TE Abundance" >> $OUTPUT_FILE
echo "COLOR,#ff0000" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE
echo "DATA" >> $OUTPUT_FILE

# Define a mapping of TE IDs to their colors based on clade names
declare -A CLADE_COLORS
CLADE_COLORS["Ale"]="#FF5733"
CLADE_COLORS["Athila"]="#1F77B4"
CLADE_COLORS["Bianca"]="#2CA02C"
CLADE_COLORS["CRM"]="#9467BD"
CLADE_COLORS["Ivana"]="#D62728"
CLADE_COLORS["Reina"]="#FF7F0E"
CLADE_COLORS["Retand"]="#8C564B"
CLADE_COLORS["SIRE"]="#E377C2"
CLADE_COLORS["Tekay"]="#7F7F7F"
CLADE_COLORS["Tork"]="#BCBD22"

# Extract TE ID and Count from the Repeat Stats section
awk '/Repeat Stats/,0' $INPUT_FILE | grep -E 'TE_[0-9]+' | awk '{print $1 "," $2}' > temp_TE_counts.txt

# Assign colors to each TE ID based on its clade
while IFS=, read -r TE_ID COUNT; do
    # Extract clade from the TE_ID (assuming the clade name is embedded in TE ID)
    CLADE=$(grep "$TE_ID" $WORKDIR/dataset_color_strip_template.txt | awk '{print $3}')
    
    # Assign color from the mapping, or default to black if unknown
    COLOR="${CLADE_COLORS[$CLADE]:-#000000}"

    # Write the formatted line to the output file
    echo "$TE_ID,$COUNT,$COLOR" >> $OUTPUT_FILE
done < temp_TE_counts.txt

# Clean up temporary file
rm temp_TE_counts.txt

echo "✅ iTOL Simple Bar Chart dataset with matching colors created: $OUTPUT_FILE"
