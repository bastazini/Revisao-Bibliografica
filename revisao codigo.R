# Instalar pacotes necessários
install.packages("httr")
install.packages("jsonlite")
install.packages("dplyr")
install.packages("RefManageR")  # Para gerar o arquivo BibTeX

# Carregar os pacotes
library(httr)
library(jsonlite)
library(dplyr)
library(RefManageR)

# URL base da API da SciELO
base_url <- "https://search.scielo.org/api/v1/"

# Termos de busca: alterações climáticas, cerrado, biodiversidade e aspectos socioeconômicos
query <- '(("climate change" OR "global warming") AND cerrado AND (biodiversity OR economy))'


# Fazer a requisição para a API da SciELO
response <- GET(
  url = base_url,
  query = list(
    q = query,        # Termos da consulta
    lang = "pt",      # Idioma principal da busca
    count = 50        # Número de resultados (máximo por consulta)
  )
)

# Verificar se a requisição foi bem-sucedida
if (status_code(response) == 200) {
  # Processar os dados retornados pela API
  result <- content(response, "text", encoding = "UTF-8")
  result_json <- fromJSON(result)
  
  # Transformar os resultados em um dataframe
  articles <- result_json$results %>%
    as.data.frame() %>%
    transmute(
      title = title,                             # Título do artigo
      keywords = sapply(keywords, paste, collapse = "; "),  # Palavras-chave
      geographic_area = sapply(affiliations, function(x) paste(unique(x$city), collapse = "; ")), # Área geográfica
      publication_year = publication_date,       # Ano de publicação
      authors = sapply(authors, paste, collapse = "; "),    # Autores
      publication_type = ifelse(country == "Brasil", "Nacional", "Internacional"), # Tipo de publicação
      doi = doi                                  # DOI (se disponível)
    )
  
  # Exportar os dados para um arquivo CSV
  write.csv(articles, "resultado_scielo.csv", row.names = FALSE, fileEncoding = "UTF-8")
  print("Exportação para CSV concluída! Arquivo salvo como 'resultado_scielo.csv'.")
  
  # Criar um arquivo BibTeX
  # Convertemos os dados em um formato compatível com o RefManageR
  bib_entries <- lapply(1:nrow(articles), function(i) {
    BibEntry(
      bibtype = "article",
      key = paste0("scielo", i),  # Gerar uma chave única para cada entrada
      title = articles$title[i],
      author = strsplit(articles$authors[i], "; ")[[1]],  # Autores separados
      year = substr(articles$publication_year[i], 1, 4), # Ano de publicação
      keywords = articles$keywords[i],
      journal = "SciELO",
      doi = articles$doi[i]
    )
  })
  
  # Salvar o arquivo BibTeX
  WriteBib(bib_entries, file = "resultado_scielo.bib")
  print("Exportação para BibTeX concluída! Arquivo salvo como 'resultado_scielo.bib'.")
  
} else {
  print(paste("Erro na requisição:", status_code(response)))
}
