#!/usr/bin/env Rscript

# Installing libraries --------------------------------------------------------------------------------------------
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("rhdf5")
# BiocManager::install("tximport")
# install.packages("optparse")

library("optparse")
library("tximport")


# Creating Options ------------------------------------------------------------------------------------------------
option_list <- list( 
	make_option(c("-t","--tx2gene_table"), default=NULL, 
		help="Table with 2 columns: TXNAME and GENEID;",
		metavar="FILE.tsv"),
	make_option(c("-a","--kallisto_abundance"), default=NULL, 
		help="abundance.h5 file path (e.g. --kallisto_abundance path/to/abundance.h5);
		tximport require the name abundance.h5 :(",
		metavar="PATH/abundance.h5"),
	make_option(c("-s","--sample"), default=NULL, 
		help="Sample name (will be the .tsv column)",
		metavar="SAMPLE"),
	make_option(c("-o","--output"), default="STOUT", 
		help="filename for the output.
		output file: tsv file with 2 columns GENEID <sample>",
		metavar="PATH/OUTPUT")
	)

description <- "Convert abundance.h5 kallisto to a gene count/tpm table. NOTE: file must be named abundance.h5.

	e.g. 
	%prog \\
		--kallisto_abundance directory/abundance.h5 \\
		--tx2gene_table      gencode_tsx2gene.tsv \\
		--sample             sample1 \\
		--output             gene_counts.tsv"

# Main Script -----------------------------------------------------------------------------------------------------

# Loading options
opt <- parse_args(OptionParser(option_list = option_list,
                               description = description))

abundance_h5_file <- strsplit(opt$kallisto_abundance,"\\s+")[[1]]
tx2gene           <- read.delim(opt$tx2gene_table, header = TRUE)
sample            <- opt$sample

# Running txImport
names(abundance_h5_file) <- sample

txi.kallisto.tsv <- tximport(
  abundance_h5_file,
  type           = "kallisto",
  tx2gene        = tx2gene,
  ignoreAfterBar = TRUE)

# Creating output table
my_counts  <- txi.kallisto.tsv$counts[,]
my_tpm     <- txi.kallisto.tsv$abundance[,]
my_gene_id <- names(my_counts)
output_table <- data.frame(
  gene_id = my_gene_id,
  counts  = my_counts,
  tpm     = my_tpm
)
colnames(output_table) <- c("gene_id", paste0(sample,"_counts"), paste0(sample,"_tpm"))
rownames(output_table) <- NULL

# Writing
write.table(file = "output", x = output_table, row.names = FALSE, sep = "\t", quote = FALSE)
