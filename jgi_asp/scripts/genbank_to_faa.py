#!/usr/bin/env python
from __future__ import print_function

import sys
import os

from Bio import SeqIO

def main(file_name, outfile):
    # stores all the CDS entries
    all_entries = []

    with open(file_name, 'r') as GBFile:

        GBcds = SeqIO.InsdcIO.GenBankCdsFeatureIterator(GBFile)

        for cds in GBcds:
            if cds.seq is not None:
                cds.id = cds.name
                cds.description = ''
                all_entries.append(cds)

    # write file
    SeqIO.write(all_entries, outfile, 'fasta')
    return

if __name__ == "__main__":
    main(*sys.argv[1:])