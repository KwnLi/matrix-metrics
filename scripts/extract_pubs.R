library(tidyverse)
source("scripts/make_publication.R")

pubspath <- "publications/publications.csv"
pubsdir <- "publications"

pubs <- read.csv(pubspath)

articles <- pubs %>% filter(Item.Type == "journalArticle") %>%
  arrange(desc(Date))

## make article categories - for reference only
# articles.doi <- articles |> select(Title, DOI)
# write.csv(articles.doi, "publications/categories.csv", row.names = FALSE)

# add categories
articles.proj <- articles |> left_join(
  read.csv("publications/categories.csv")
)


for(i in seq_len(nrow(articles.proj))){
  title.i <- articles.proj$Title[i]
  author.i <- articles.proj$Author[i] |> abbreviate_names()
  journal.i <- articles.proj$Publication.Title[i]
  volume.i <- articles.proj$Volume[i]
  issue.i <- articles.proj$Issue[i]
  page.i <- articles.proj$Pages[i]
  year.i <- articles.proj$Publication.Year[i]
  date.i <- articles.proj$Date[i]
  url_source.i <- articles.proj$Url[i]
  doi.i <- articles.proj$DOI[i]
  project.i <- articles.proj$project[i]
  
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
    project = project.i,
    file_path = file.path(file_path.i,"index.qmd"),
  )
}
