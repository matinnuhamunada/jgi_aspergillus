for item in /home/bgcflow_admin/other_projects/jgi_aspergillus/data/raw/*
    do (cd data/raw && ln -s $item $(basename $item))
done

snakemake -c $N --use-conda --configfile config/jgi_config.yaml --snakefile config/jgi_asp/Snakefile 