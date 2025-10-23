# do not run this script, the files are already renamed!
# keeping for the record only

library(tidyverse)

gt_old <- list.files("orus-ground-truth", full.names = TRUE)
gt_old_sel <- gt_old[str_detect(gt_old, "png|txt")]

# Files to REMOVE (those NOT matching png or txt)
gt_old_rm <- gt_old[!gt_old %in% gt_old_sel]

# Remove unwanted files
file.remove(gt_old_rm)


### ========= Renaming ==============### 

# Получаем список всех файлов и сортируем для надежности
files <- sort(list.files("orus-ground-truth", pattern = "word_\\d{3,}(.gt)?(.txt|.png)$", full.names = TRUE))

# Оставим только basename для переименования
basenames <- basename(files)

# Создадим тиббл, чтобы проще было переименовывать
names_tbl <- tibble(old_name = basenames) |> 
  mutate(word_id = str_remove(basenames, "\\.(gt\\.txt|txt|png)$")) |> 
  mutate(word_base = str_replace(word_id, "(_word_\\d+).*", "\\1")) |> 
  group_by(word_base) |> 
  mutate(new_id = sprintf("word_%04d", cur_group_id()))  |> 
  ungroup()  |> 
  mutate(
    suffix = str_extract(old_name, "\\.(gt\\.txt|txt|png)$"),
    new_name = paste0(new_id, suffix)
  ) 

new_names <- paste0("orus-ground-truth/", names_tbl |> 
                      pull(new_name))

new_names

# Массовое переименование
file.rename(files, new_names)

# ура, все получилось! 
