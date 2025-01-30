#!/bin/bash

# Define working directory (update if needed)
WORKDIR="/data/users/jvaleriano/assembly_course/Annotation_output/TEsorterTE"

# Define output file
OUTPUT_FILE="$WORKDIR/dataset_color_strip_template.txt"

# Define clades and their corresponding colors
declare -A CLADE_COLORS
CLADE_COLORS["Ale"]="#FF5733"      # Orange-Red
CLADE_COLORS["Athila"]="#1F77B4"   # Blue
CLADE_COLORS["Bianca"]="#2CA02C"   # Green
CLADE_COLORS["CRM"]="#9467BD"      # Purple
CLADE_COLORS["Ivana"]="#D62728"    # Red
CLADE_COLORS["Reina"]="#FF7F0E"    # Orange
CLADE_COLORS["Retand"]="#8C564B"   # Brown
CLADE_COLORS["SIRE"]="#E377C2"     # Pink
CLADE_COLORS["Tekay"]="#7F7F7F"    # Gray
CLADE_COLORS["Tork"]="#BCBD22"     # Yellow

# Create header for iTOL dataset file
echo -e "#=================================================================#" > $OUTPUT_FILE
echo -e "# iTOL Color Strip Dataset                                       #" >> $OUTPUT_FILE
echo -e "#=================================================================#" >> $OUTPUT_FILE
echo -e "DATA" >> $OUTPUT_FILE

# Loop through each clade and extract TE IDs
for CLADE in "${!CLADE_COLORS[@]}"; do
    grep -e "$CLADE RT" $WORKDIR/*.rexdb-plant.cls.tsv | cut -f1 | \
    sed 's/:/_/' | sed 's/#.*//' | \
    awk -v color="${CLADE_COLORS[$CLADE]}" -v clade="$CLADE" '{print $1, color, clade}' >> $OUTPUT_FILE
done

sed -E 's|.*/([^/]+)tsv_|\1 |' $OUTPUT_FILE > cleaned_dataset_color_strip.txt

echo "Color strip dataset generated: $OUTPUT_FILE"
