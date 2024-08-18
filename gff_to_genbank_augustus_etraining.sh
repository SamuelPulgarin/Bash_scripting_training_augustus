#!/bin/bash

gff_file=$1
fasta_file=$2

echo "¿Desea verificar el formato de su archivo gff3? Si=1 | No=0"
read verify_gff3

if [ "$verify_gff3" -ne 0 ]; then
    echo "***************************************************************"
    ./format_gff3_R570.sh $gff_file
    echo "***************************************************************"
fi

if [ "$verify_gff3" -ne 0 ]; then
    echo "***************************************************************"
    echo "*          Convirtiendo gff3 a genbank...                     *"
    python3 gff_to_genbank.py Saccharum_hybrid_cultivar_formatted_R570.gff3 $fasta_file
    echo "*          Archivo genbank generado.                          *"
    echo "*          Saccharum_hybrid_cultivar_formatted_R570.gb        *"
    echo "***************************************************************"
else
    echo "***************************************************************"
    echo "*          Convirtiendo gff3 a genbank...                     *"
    python3 gff_to_genbank.py $gff_file $fasta_file
    echo "*          Archivo genbank generado.                          *"
    echo "*          Saccharum_hybrid_cultivar_formatted_R570.gb        *"
    echo "***************************************************************"
fi

echo "***************************************************************"
./format_genbank_R570.sh
echo "***************************************************************"

echo "***************************************************************"
echo "*          ¡Labores finalizadas!                              *"
echo "*          Gracias por usar nuestros servicios.               *"
echo "***************************************************************"






