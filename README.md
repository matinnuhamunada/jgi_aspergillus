# jgi_aspergillus
Genome mining of Aspergillus strains from JGI Mycocosm: https://genome.jgi.doe.gov/portal/Aspwhosequencing/Aspwhosequencing.info.html

## Data acquisition & preparation
Nucleotide sequence and annotation of Aspergillus species was downloaded from Mycocosm. Only Filtered Models ("best") and all Assemblies are downloaded.

**Note to self**: 
- 4 zipped files containing annotation and assemblies are stored in the CeMiSt drive
```bash
├── bulk_data_82292-1.zip (321M)
├── bulk_data_82292-2.zip (2.4G)
├── bulk_data_82292-3.zip (343M)
└── bulk_data_82292-4.zip (83M)
```
## How to Use
This repository is a Snakemake sub-workflow or plugin to BGCFlow. This sub-workflow aims to clean the data and format it according to BGCFlow data structure. In short, the repository contains:
- Jupyter Notebook to prepare metadata and config files
- A snakemake workflow to generate `.gbk` files from JGI formatted `.gff` and `.fasta` files.


### 1. Getting a clone of this repository
Get a clone of this repository by:
```bash
git clone git@github.com:matinnuhamunada/jgi_aspergillus.git
```

### 2. Setting up BGCFlow
Follow installation instruction of [BGCFlow](https://github.com/NBChub/bgcflow) to set it up in your machine.

### 3. Copy all contents to BGCFlow `config` folder
If you don't need to update any metadata from the 1st step, you can directly copy all contents of this repository to BGCFlow `config` folder.
```bash
cp <this repository path>/* <BGCFlow path>/config/. #change path accordingly
```

### 4. Setting up config file
Add this project into BGCFlow `config.yaml`, under the `config` parameters:
```yaml
projects:
# Project 1
  - name: jgi_asp
    samples: config/jgi_asp/tables/samples.csv
    rules: config/jgi_asp/project_config.yaml
    gtdb-tax: config/jgi_asp/tables/JGI_taxonomy.csv
``` 

### 5. Extract raw data
Extract all 4 of the zipped files to `BGCFlow data/raw/` directory (we can also create symlinks, or change the file paths in the `config/tables/units.csv`)

### 6. Run this sub-workflow
Move to BGCflow directory and run snakemake with this parameters (better do a dry run first).
```bash
cd <BGCFlow directory>
conda activate snakemake
snakemake -c $N --use-conda --configfile config/jgi_config.yaml --snakefile config/jgi_asp/Snakefile -n #remove -n to run
```

### 7. Run BGCflow
After all intermediate files in `interim/prokka/` has been generated, we need to tell BGCFlow that the input were manually added.
```bash
snakemake --until prokka --touch -c $N -n #remove -n to run
```
When all the intermediate data has been updated, we can run BGCFlow as usual:
```bash
snakemake --use-conda -c $N -n #remove -n to run
```