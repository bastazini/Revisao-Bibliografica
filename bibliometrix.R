string search: ("climate change" OR "global warming" OR "climatic variability" OR "climate variability")
AND ("Cerrado" OR "Brazilian savanna" OR "Bacia do Araguaia" OR "Araguaia River Basin" OR "Araguaia watershed")
AND ("biodiversity" OR "species loss" OR "species richness" OR "species diversity" OR "ecosystem" OR "ecosystems")
AND ("socio-economic" OR "livelihood" OR "rural communities" OR "income" OR "migration" OR "land use change")
AND ("agriculture" OR "crop production" OR "livestock" OR "agroecosystem" OR "agribusiness" OR "food security")

require(bibliometrix)
file_path <- "cerrado.bib"

M <- convert2df(file_path, dbsource = "wos", format = "bibtex")

results <- biblioAnalysis(M)
summary(results)

NetMatrix <- biblioNetwork(M, analysis = "co-occurrences", network = "keywords", sep = ";")
networkPlot(NetMatrix, normalize = TRUE, weighted = TRUE, n = 30, Title = "Keyword Co-Occurrence Network")

NetMatrix <- biblioNetwork(M, analysis = "collaboration", network = "authors", sep = ";")
networkPlot(NetMatrix, n = 30, Title = "Collaboration Network")

thematicMap(M, field = "keywords", n = 250)

biblioshiny()





