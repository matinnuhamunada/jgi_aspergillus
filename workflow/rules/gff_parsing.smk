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

rule gff_to_gbk:
    input: 
        gff = lambda wildcards: GFF[wildcards.strains],
        fna = "data/interim/fasta/{strains}.fna",
    output:
        gff = "data/interim/prokka/{strains}/{strains}.gff",
        faa = "data/interim/prokka/{strains}/{strains}.faa",
        gbk = "data/interim/prokka/{strains}/{strains}.gbk",
    conda:
        "../envs/gff_parsing.yaml"
    threads: 4
    log:
        "workflow/report/logs/gff_parsing/{strains}/gff_to_gbk-{strains}.log"
    shell:
        """
        gunzip -c -d {input.gff} > {output.gff} 2>> {log}
        python workflow/scripts/gff_to_genbank.py {output.gff} {input.fna} {output.gbk} 2>> {log}
        any2fasta {output.gbk} {output.faa} 2>> {log}
        """