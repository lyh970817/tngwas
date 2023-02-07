if (length(args) != 6) {
  stop(
    "Specify input file, output directory, \
    'chr', 'bp' , 'snp' and 'p' columns ",
    call. = FALSE
  )
}

sum <- data.table::fread(arg[1])

bitmap(
  file = paste0(args[2], "man.png"), type = "png16m",
  width = 7, height = 7, res = 300
)
par(cex.axis = 1.1, cex.lab = 1.3)
qqman::manhattan(sum,
  suggestiveline = -log10(1e-05),
  chr = arg[3], bp = arg[4], snp = arg[5], p = arg[6],
  col = c("#9CBEBD", "#95A39D"),
  cex = 0.5,
  suggestiveline = -log10(1e-05),
  genomewideline = -log10(5e-08)
)

dev.off()

bitmap(
  file = paste0(args[2], "qq.png"), type = "png16m",
  width = 7, height = 7, res = 300
)
par(mar = c(5, 5, 1, 1))
qqman::qq(sum[[arg[6]]],
  cex.axis = 1.1,
  cey.axis = 1.1,
  cex.lab = 1.3,
  cey.lab = 1.3,
  xlim = c(0, 10),
  ylim = c(0, 10)
)

dev.off()
