library(tidyverse)
library(tesseract)

images <- list.files("val", pattern = "png", full.names = TRUE)
text_paths <- list.files("val", pattern = "txt", full.names = TRUE) 

texts <- map_chr(text_paths, readLines, encoding = "UTF-8") 


val_data <- tibble(
  image_path = images,
  truth = texts, 
  rus = tesseract::ocr(image_path, engine = "rus") |> 
    trimws(),
  orus = tesseract::ocr(image_path, engine = "orus") |> 
    trimws()
)

# доля правильно распознанных слов (=сочетаний символов, это не всегда буквально слова)

word_stats_rus <- val_data |> 
  mutate(rus_true = truth == rus) |> 
  summarise(true_share = sum(rus_true) / 1040)
word_stats_rus

word_stats_orus <- val_data |> 
  mutate(orus_true = truth == orus) |> 
  summarise(true_share = sum(orus_true) / 1040)
word_stats_orus

# в каких словах чаще встречаются ошибки?

errors_orus <- val_data |> 
  filter(truth != orus) 


