#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 5) {
  stop(
    "Specify input file, output directory, \
    'chr', 'bp' , 'snp' and 'p' columns ",
    call. = FALSE
  )
}

sum <- data.table::fread(args[1])

bitmap(
  file = paste0(args[1], "_man.png"), type = "png16m",
  width = 7, height = 7, res = 300
)
par(cex.axis = 1.1, cex.lab = 1.3)


qqman::manhattan(sum,
  suggestiveline = -log10(1e-05),
  chr = args[2], bp = args[3], snp = args[4], p = args[5],
  col = c("#9CBEBD", "#95A39D"),
  cex = 0.5,
  genomewideline = -log10(5e-08)
)

dev.off()
