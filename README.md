# jgi_aspergillus
Genome mining of Aspergillus species from JGI Mycocosm: https://genome.jgi.doe.gov/portal/Aspwhosequencing/Aspwhosequencing.info.html

## Data acquisition
Nucleotide sequence and annotation of Aspergillus species was downloaded from Mycocosm. Only Filtered Models ("best") and all Assemblies are downloaded (9 GB).

**Note to self**: 
- 4 zipped files containing annotation and assemblies are stored in the CeMiSt drive

## How to Use
This repository is a Snakemake sub-workflow or plugin to BGCFlow. This sub-workflow aims to clean the data and format it according to BGCFlow data structure. In short, the repository contains:
- Jupyter Notebook to prepare metadata and config files
- A snakemake workflow to generate `.gbk` files from JGI formatted `.gff` and `.fasta` files.

### Metadata Preparation
- Notebook will generate 
