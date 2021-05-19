# txImport

![](https://img.shields.io/github/license/barreiro-r/tximport)

Script to convert [kallisto](https://pachterlab.github.io/kallisto/) (1) transcript expression to gene expression (counts and TPM) using [txImport](https://bioconductor.org/packages/release/bioc/html/tximport.html) (2);

## How to use:
```
Rscript	kallisto_tx2gene.R \
		--kallisto_abundance directory/abundance.h5 \
		--tx2gene_table      gencode_tsx2gene.tsv \
		--sample             sample \
		--output             gene_counts.tsv \
```

See more information in `Rscript kallisto_tx2gene.R -h`

## References

(1) Nicolas L Bray, Harold Pimentel, Páll Melsted and Lior Pachter, Near-optimal probabilistic RNA-seq quantification, Nature Biotechnology 34, 525–527 (2016), doi:10.1038/nbt.3519

(2) Soneson C, Love MI, Robinson MD (2015). “Differential analyses for RNA-seq: transcript-level estimates improve gene-level inferences.” F1000Research, 4. doi: 10.12688/f1000research.7563.1.
