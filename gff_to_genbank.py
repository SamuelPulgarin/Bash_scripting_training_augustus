#!/usr/bin/env python
#python3 gff_to_genbank.py GFF-file  FASTA-file

from __future__ import print_function

import sys
import os

from Bio import SeqIO
from Bio import Seq
from Bio import SeqFeature
from Bio.SeqRecord import SeqRecord

from BCBio import GFF

# pip install biopython
# pip install bcbio-gff

def main(gff_file, fasta_file):
    out_file = "Saccharum_hybrid_cultivar_formatted_R570.gb"
#    out_file = "%s.gb" % os.path.splitext(gff_file)[0]
    fasta_input = SeqIO.to_dict(SeqIO.parse(fasta_file, "fasta"))
    gff_iter = GFF.parse(gff_file, fasta_input)

    records = []
    for rec in _check_gff(_fix_ncbi_id(_extract_regions(gff_iter))):
        # Obtener las coordenadas del inicio y fin del gen
        start_coord = rec.features[0].location.start
        end_coord = rec.features[0].location.end
        
        # Aquí agregamos la información a la sección SOURCE
        rec.annotations["source"] = f"{start_coord}..{end_coord}"
        
        # Añadir el registro a la lista
        records.append(rec)
    
    # Escribir los registros en el archivo GenBank
    SeqIO.write(records, out_file, "genbank")


def _fix_ncbi_id(fasta_iter):
    for rec in fasta_iter:
        if len(rec.name) > 16 and rec.name.find("|") > 0:
            new_id = [x for x in rec.name.split("|") if x][-1]
            print("Warning: shortening NCBI name %s to %s" % (rec.id, new_id))
            rec.id = new_id
            rec.name = new_id
        for i in range(len(rec.features)):
            if len(rec.features[i].type)>15:
                rec.features[i].type=rec.features[i].type[0:15]
        yield rec


def _check_gff(gff_iterator):
    for rec in gff_iterator:
        if rec.seq is None:
            print("Warning: FASTA sequence not found for '%s' in GFF file" % (rec.id))
        yield _flatten_features(rec)


def _extract_regions(gff_iterator):
    for rec in gff_iterator:
        # Verificar si hay características presentes
        if rec.features:
            # Obtener las posiciones de inicio y fin de todas las características
            start_pos = [feature.location.start for feature in rec.features]
            end_pos = [feature.location.end for feature in rec.features]
            
            # Calcular la posición de inicio y fin del fragmento de secuencia
            loc = min(start_pos)
            endloc = max(end_pos)
            
            # Ajustar las ubicaciones de las características y subcaracterísticas
            for feature in rec.features:
                feature.location = SeqFeature.FeatureLocation(
                    SeqFeature.ExactPosition(feature.location.start - loc),
                    SeqFeature.ExactPosition(feature.location.end - loc),
                    strand=feature.location.strand
                )
                for sub_feature in feature.sub_features:
                    sub_feature.location = SeqFeature.FeatureLocation(
                        SeqFeature.ExactPosition(sub_feature.location.start - loc),
                        SeqFeature.ExactPosition(sub_feature.location.end - loc),
                        strand=sub_feature.location.strand
                    )
            
            rec.seq = rec.seq[loc:endloc]
            rec.annotations["molecule_type"] = "DNA"
                
            yield rec

        #else:
            #print(f"Warning: No features found for record {rec.id}")


def _flatten_features(rec):
    out = []
    for f in rec.features:
        cur = [f]
        while len(cur) > 0:
            nextf = []
            for curf in cur:
                out.append(curf)
                if len(curf.sub_features) > 0:
                    nextf.extend(curf.sub_features)
            cur = nextf
    rec.features = out
    return rec

if __name__ == "__main__":
    main(*sys.argv[1:])

