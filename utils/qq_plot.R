#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop(
    "Specify input file, output directory and 'p' column ",
    call. = FALSE
  )
}

sum <- data.table::fread(args[1])

bitmap(
  file = paste0(args[1], "_qq.png"), type = "png16m",
  width = 7, height = 7, res = 300
)


par(mar = c(5, 5, 1, 1))
qqman::qq(sum[[args[2]]],
  xlim = c(0, 10),
  ylim = c(0, 10)
)

dev.off()
