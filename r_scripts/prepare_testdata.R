# --- Prepare TEST data for OCR evaluation ---

library(tidyverse)

# === 0. Пути к данным ===
train_val_dir <- "/Users/anastasiabogdanova/R_directory/Iskra_ocr"
source_dir <- "/Users/anastasiabogdanova/R_directory/orus_ground_truth_2"
output_dir <- "/Users/anastasiabogdanova/R_directory/orus_test"

# === 1. Определяем последний использованный индекс в train/val ===
train_val_files <- list.files(
  train_val_dir, recursive = TRUE,
  pattern = "word_\\d+\\.(png|gt\\.txt)$", full.names = TRUE
)

if (length(train_val_files) == 0) {
  stop("Не удалось найти файлы word_XXXX в папке Iskra_ocr.")
}

last_index <- train_val_files |>
  str_extract("word_(\\d+)") |>
  str_extract("\\d+") |>
  as.integer() |>
  max(na.rm = TRUE)

start_index <- last_index + 1
message("🟦 Последний индекс в train/val: word_", last_index)
message("🟩 Новый индекс для тестовых данных начнётся с: word_", start_index)

# === 2. Читаем тестовые файлы ===
files <- list.files(source_dir, full.names = TRUE, pattern = "\\.(png|gt\\.txt)$")

if (length(files) == 0) {
  stop("В папке с тестовыми данными не найдено файлов .png или .gt.txt.")
}

# Извлекаем старые идентификаторы
basenames <- str_extract(basename(files), "word_\\d+")
unique_words <- unique(na.omit(basenames))
unique_words_sorted <- sort(unique_words)

# === 3. Проверка на “дырки” (отсутствие пар) ===
# получаем списки по типу
pngs <- basename(files[str_detect(files, "\\.png$")])
txts <- basename(files[str_detect(files, "\\.gt\\.txt$")])

png_base <- str_remove(pngs, "\\.png$")
txt_base <- str_remove(txts, "\\.gt\\.txt$")

missing_png <- setdiff(txt_base, png_base)
missing_txt <- setdiff(png_base, txt_base)

if (length(missing_png) > 0) {
  message("⚠️ Нет соответствующих PNG для ", length(missing_png), " ground truth файлов:")
  print(head(missing_png, 10))
}

if (length(missing_txt) > 0) {
  message("⚠️ Нет соответствующих GT файлов для ", length(missing_txt), " изображений:")
  print(head(missing_txt, 10))
}

if (length(missing_png) == 0 && length(missing_txt) == 0) {
  message("✅ Все пары файлов (.png и .gt.txt) совпадают.")
}

# === 4. Создаём новые имена ===
new_indices <- seq(start_index, by = 1, length.out = length(unique_words_sorted))
wordmap <- tibble(
  old = unique_words_sorted,
  new = sprintf("word_%d", new_indices)
)

# === 5. Связываем старые пути с новыми ===
files_tbl <- tibble(
  old_path = files,
  basename = basename(files),
  ext = str_extract(basename(files), "(gt\\.txt|png)$"),
  old_word = str_extract(basename(files), "word_\\d+")
) |>
  left_join(wordmap, by = c("old_word" = "old")) |>
  mutate(
    new_basename = paste0(new, ".", ext),
    new_path = file.path(output_dir, new_basename)
  )

# === 6. Копируем файлы в новую папку ===
dir.create(output_dir, showWarnings = FALSE)
copied <- file.copy(files_tbl$old_path, files_tbl$new_path, overwrite = TRUE)

message("✅ Скопировано ", sum(copied), " файлов в ", output_dir)

# === 7. Сохраняем таблицу переименования ===
rename_log <- files_tbl |>
  select(old_path, new_path, old_word, new, ext)

write_csv(rename_log, file.path(output_dir, "rename_log.csv"))
message("📄 Файл rename_log.csv сохранён в ", output_dir)

# === 8. Финальный отчёт ===
message("🏁 Подготовка тестовой выборки завершена.")
message("   - Проверено файлов: ", nrow(files_tbl))
message("   - Начальный индекс: ", start_index)
message("   - Папка назначения: ", output_dir)
