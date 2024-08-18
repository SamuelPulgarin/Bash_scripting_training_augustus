#!/bin/bash

gff_file=$1

echo -e "*          Formateando el archivo: $gff_file...               *"

sed -E 's/\.([0-9]+|[a-zA-Z]+[0-9]*)//g' $gff_file >> Saccharum_hybrid_cultivar_formatted_R570.gff3

echo -e "*          $gff_file formateado con exito.                    *"
echo -e "*          Salida: Saccharum_hybrid_cultivar_formatted_R570.gff3*"

