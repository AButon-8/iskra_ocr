library(tidyverse)
library(tesseract)
library(stringdist)

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

# нормализация

val_data_norm <- val_data |> 
  # приводим все к нижнему регистру
  mutate(truth = tolower(truth), 
         rus = tolower(rus),
         orus = tolower(orus)) |> 
  # удаляем пунктуацию
  mutate(truth = str_remove_all(truth, "[[:punct:]|<>]"),
         rus = str_remove_all(rus, "[[:punct:]|<>]"),
         orus = str_remove_all(orus, "[[:punct:]|<>]"),
         )

# доля неправильно распознанных слов (=сочетаний символов, это не всегда буквально слова)

word_stats_rus <- val_data_norm |> 
  mutate(rus_true = truth == rus) |> 
  summarise(true_share = sum(rus_true) / nrow(val_data_norm))
word_stats_rus

word_stats_orus <- val_data_norm |> 
  mutate(orus_true = truth == orus) |> 
  summarise(true_share = sum(orus_true) / nrow(val_data_norm))
word_stats_orus

# в каких словах чаще встречаются ошибки?

errors_orus <- val_data |> 
  filter(truth != orus) 

# расстояние в символах

char_stats_orus <- val_data_norm |> 
  mutate(len = nchar(truth),
         orus_ed = stringdist(truth, orus, method = "lv"),
         cer_row = orus_ed / pmax(len, 1))

# micro‑CER 
cer_micro <- sum(char_stats_orus$orus_ed) / sum(char_stats_orus$len)
cer_micro

# macro-CER
cer_macro <- mean(char_stats_orus$cer_row)
cer_macro

# точность по символам
char_accuracy <- 1 - cer_micro
char_accuracy

