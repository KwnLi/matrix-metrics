library(tidyverse)
source("scripts/make_publication.R")

pubspath <- "publications/publications.csv"
pubsdir <- "publications"

pubs <- read.csv(pubspath)

articles <- pubs %>% filter(Item.Type == "journalArticle") %>%
  arrange(desc(Date))

for(i in seq_len(nrow(articles))){
  title.i <- articles$Title[i]
  author.i <- articles$Author[i] |> abbreviate_names()
  journal.i <- articles$Publication.Title[i]
  volume.i <- articles$Volume[i]
  issue.i <- articles$Issue[i]
  page.i <- articles$Pages[i]
  year.i <- articles$Publication.Year[i]
  date.i <- articles$Date[i]
  url_source.i <- articles$Url[i]
  doi.i <- articles$DOI[i]
  # categories.i <- 
  
  titlewords <- gsub("<[^>]+>", "", title.i) |>        # remove <i>…</i> and any HTML tags
    gsub("[^A-Za-z0-9 _-]", "", x = _) |>   # strip chars illegal in dir names
    strsplit(" ") |> unlist()
  
  file_path.i <- do.call(
    file.path,
    list(pubsdir, 
         paste(c(year.i,titlewords[1:3][!is.na(titlewords[1:3])]),collapse="_")
         )
    )
  
  if(!dir.exists(file_path.i)){
    dir.create(file_path.i)
  }
  
  make_publication(
    title = title.i,
    author = author.i,
    journal = journal.i,
    volume = volume.i,
    issue = issue.i,
    page = page.i,
    year = year.i,
    date = date.i,
    url_source = url_source.i,
    doi = doi.i,
    file_path = file.path(file_path.i,"index.qmd"),
  )
}
