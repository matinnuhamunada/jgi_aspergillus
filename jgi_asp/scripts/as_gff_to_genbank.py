from antismash.common import gff_parser
from antismash.common import record_processing

import sys
import os
from pathlib import Path

from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord

def extract_aa(records):
    faa = []
    for record in records:
        for feat in record.features:
            if feat.type=="CDS":
                assert len(feat.qualifiers['translation'])==1
                gene_id = feat.qualifiers['gene'][0]
                locus_tag = feat.qualifiers['locus_tag']
                aa = feat.qualifiers['translation'][0]

                faa_record = SeqRecord(
                    Seq(aa),
                    id=locus_tag,
                    name=locus_tag,
                    description=gene_id,
                )

                faa.append(faa_record)
    return faa

def jgi_gff_to_gbk(fasta, taxon, gff, metadata, genome_id):
    records = record_processing.parse_input_sequence(fasta, 
                                                     taxon=taxon,
                                                     gff_file=gff)
    records_biopython = [r.to_biopython() for r in records]
    
    with open(metadata, 'r') as f:
        taxonomy = f.read().split(",")
        definition = " ".join(taxonomy)
        source = " ".join(taxonomy[0:2])
    
    for record in records_biopython:
        old_name = record.name
        new_name = f"{genome_id}_{old_name.split('_')[-1]}"
        record.name = new_name
        record.id = new_name
        record.annotations['organism'] = source
        record.annotations['source'] = source
        record.description = definition
        for feat in record.features:
            if feat.type=="CDS":
                assert len(feat.qualifiers['translation'])==1
                feat.qualifiers['locus_tag'] = f"{record.name}-{feat.qualifiers['ID'][0]}" 
    return records_biopython

def jgi_convert_gff(fasta, taxon, gff, metadata, outdir, genome_id):
    records = jgi_gff_to_gbk(fasta, 'fungi', gff, metadata, genome_id)
    faa = extract_aa(records)
    
    # generate outdir
    outdir = Path(outdir)
    outdir.mkdir(parents=True, exist_ok=True)
    
    # write files
    SeqIO.write(records, outdir / f"{genome_id}.gbk", "genbank")
    SeqIO.write(records, outdir / f"{genome_id}.fna", "fasta")
    SeqIO.write(faa, outdir / f"{genome_id}.faa", "fasta")
    return

if __name__ == "__main__":
    jgi_convert_gff(*sys.argv[1:])
