# do not run this script! all files are already renamed and split into train and validation

library(tidyverse)

files <- list.files("orus_ground_truth2", full.names = TRUE)

# столько файлов для валидации нам не нужно, 
# часть отберем и добавим в тренировочные данные

basenames <- str_extract(basename(files), "word_\\d+")

# get unique base names
unique_words <- unique(basenames)

# split
set.seed(24) # for reproducibility
train_idx <- sample(seq_along(unique_words), 1800)
train_words <- unique_words[train_idx]
val_words <- unique_words[-train_idx]

# у нас уже есть тренировочные данные, они доходят до word_3473
# поэтому нам надо переименовать файлы

# начальный индекс (последний старый + 1)
start_index <- 3474

# новые имена файлов (тренировочные)
train_words_sorted <- sort(train_words)

train_indices <- seq(start_index, by=1, length.out = length(train_words_sorted))

train_wordmap <- tibble(
  old = train_words_sorted,
  new = sprintf("word_%d", train_indices)
)

# новые имена файлов (валидационные)
val_words_sorted <- sort(val_words)

val_indices <- seq(start_index + length(train_words_sorted), by=1, length.out = length(val_words_sorted))
val_wordmap <- tibble(
  old = val_words_sorted,
  new = sprintf("word_%d", val_indices)
)

# сводим в одну таблицу маппинга
wordmap <- bind_rows(
  mutate(train_wordmap, subset = "train"),
  mutate(val_wordmap, subset = "val")
)

# Связываем исходные файлы с новыми именами
files_tbl <- tibble(
  old_path = files,
  basename = basename(files),
  ext = str_extract(basename, "(gt\\.txt|png)$"),
  old_word = str_extract(basename, "word_\\d+")
)  |> 
  left_join(wordmap, by = c("old_word" = "old")) |> 
  mutate(new_basename = paste0(new, ".", ext),
         new_path = file.path(subset, new_basename))

# создаем папки и перемещаем
dir.create("train", showWarnings = FALSE)
dir.create("val", showWarnings = FALSE)

file.copy(files_tbl$old_path, files_tbl$new_path)

# после этого я добавляем файлы из train к ground_truth, а файлы из val оставляем на месте