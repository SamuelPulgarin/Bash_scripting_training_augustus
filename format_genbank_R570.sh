#!/bin/bash

input_file="Saccharum_hybrid_cultivar_formatted_R570.gb"
output_file="Etraining_saccharum_specie_R570.gb"

mRNA_positions=()
CDS_positions=()

origin_line=false

ranges_overlap() {
    local range1=$1
    local range2=$2
    local start1=$(echo "$range1" | awk -F "\.\." '{print $1}')
    local end1=$(echo "$range1" | awk -F "\.\." '{print $2}')
    local start2=$(echo "$range2" | awk -F "\.\." '{print $1}')
    local end2=$(echo "$range2" | awk -F "\.\." '{print $2}')
    if (( start1 <= end2 && end1 >= start2 )); then
        return 0
    else
        return 1
    fi
}

echo "*          Organizando $input_file...                         *"
while IFS= read -r linea || [[ -n "$linea" ]]; do

# SECTIONS
    if [[ "$linea" =~ ^(LOCUS|DEFINITION|ACCESSION|VERSION|KEYWORDS) ]]; then
        echo "$linea" >> "$output_file"
        origin_line=false
    fi

# FEATURES
    if [[ "$linea" =~ ^(SOURCE) ]]; then
        echo "FEATURES             Location/Qualifiers" >> "$output_file"
        echo "     source          $(echo "$linea" | awk '{print $2}')" >> "$output_file"
    fi

    if [[ "$linea" =~ ^\ {5}mRNA ]]; then
        mRNA=$(echo "$linea" | awk '{print $2}' | tr -d 'complement()' | tr -d ' ')
        mRNA_positions+=("$mRNA")
    fi

    if [[ "$linea" =~ ^\ {5}CDS ]]; then
        CDS=$(echo "$linea" | awk '{print $2}' | tr -d 'complement()' | tr -d ' ')

        is_overlap=false
        for existing_range in "${CDS_positions[@]}"; do
            if ranges_overlap "$existing_range" "$CDS"; then
                is_overlap=true
                break
            fi
        done
        if ! $is_overlap; then
            CDS_positions+=("$CDS")
        fi
    fi

    if [[ "$linea" =~ ^(ORIGIN) ]]; then
        mRNA_positions_parse=$(echo "${mRNA_positions[@]}" | tr ' ' '\n' | awk '!seen[$0]++' | tr '\n' ',' | sed 's/,$//')
        CDS_positions_parse=$(echo "${CDS_positions[@]}" | tr ' ' '\n' | awk '!seen[$0]++' | tr '\n' ',' | sed 's/,$//')

        echo "     mRNA            join(${mRNA_positions_parse[@]})" >> "$output_file"
        echo "     CDS             join(${CDS_positions_parse[@]})" >> "$output_file"
        
        mRNA_positions=()
        CDS_positions=()
    fi

# ORIGIN - SEQUENCE
    if [[ "$origin_line" == true ]]; then
        echo "$linea" >> "$output_file"
    fi

    if [[ "$linea" =~ ^(ORIGIN) ]]; then
        echo "$linea" >> "$output_file"
        origin_line=true
    fi

done < "$input_file"

echo "*          Archivo organizado con exito!!!                    *"
echo "*          Archivo: $output_file.                             *"
