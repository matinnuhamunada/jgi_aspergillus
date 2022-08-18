rule copy_fasta:
    input:
        fna = lambda wildcards: FNA[wildcards.strains],
    output:
        fna = "data/interim/fasta/{strains}.fna" 
    conda:
        "../envs/gff_parsing.yaml"
    log: "workflow/report/logs/gff_parsing/{strains}/copy_fasta-{strains}.log"
    shell:
        """
        gunzip -c -d {input.fna} > {output} 2>> {log}
        """

rule extract_meta_prokka:
    input:
        fna = "data/interim/fasta/{strains}.fna",
    output:
        org_info = "data/interim/prokka/{strains}/organism_info.txt",
    conda:
        "../envs/bgc_analytics.yaml"
    log: "workflow/report/logs/prokka/extract_meta_prokka/extract_meta_prokka-{strains}.log"
    params:
        samples_path = config['samples'],
    shell:
        """
        python workflow/bgcflow/bgcflow/data/get_organism_info.py {wildcards.strains} \
            "{params.samples_path}" data/interim/assembly_report/ data/interim/prokka/ 2>> {log}
        """

rule gff_to_gbk:
    input:
        org_info = "data/interim/prokka/{strains}/organism_info.txt",
        gff = lambda wildcards: GFF[wildcards.strains],
        fna = "data/interim/fasta/{strains}.fna",
    output:
        gff = "data/interim/prokka/{strains}/{strains}.gff",
        gbk = "data/interim/prokka/{strains}/{strains}.gbk",
        faa = "data/interim/prokka/{strains}/{strains}.faa",
        fna = "data/interim/prokka/{strains}/{strains}.fna",
    conda:
        "../envs/antismash.yaml"
    threads: 1
    log:
        "workflow/report/logs/gff_parsing/{strains}/gff_to_gbk-{strains}.log"
    params:
        taxon = "fungi",
        outdir= "data/interim/prokka/{strains}/"
    shell:
        """
        gunzip -c -d {input.gff} > {output.gff}
        python config/jgi_asp/scripts/as_gff_to_genbank.py {input.fna} {params.taxon} {output.gff} {input.org_info} {params.outdir} {wildcards.strains} 2>> {log}
        """