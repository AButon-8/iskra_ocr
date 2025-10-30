# === ОЦЕНКА КАЧЕСТВА OCR НА ТЕСТОВЫХ ДАННЫХ ===

library(tidyverse)
library(tesseract)
library(stringdist)

# --- Пути ---
test_dir <- "/Users/anastasiabogdanova/R_directory/Iskra_ocr/test"

# --- Загружаем тестовые файлы ---
images <- list.files(test_dir, pattern = "\\.png$", full.names = TRUE)
text_paths <- list.files(test_dir, pattern = "\\.gt\\.txt$", full.names = TRUE)

# Проверим, совпадает ли количество
if (length(images) != length(text_paths)) {
  warning("⚠️ Количество изображений и текстов не совпадает! Проверка индексов...")
  
  img_ids <- str_extract(basename(images), "\\d+")
  txt_ids <- str_extract(basename(text_paths), "\\d+")
  
  missing_imgs <- setdiff(txt_ids, img_ids)
  missing_txts <- setdiff(img_ids, txt_ids)
  
  if (length(missing_imgs) > 0) cat("Нет изображений для:", paste(missing_imgs, collapse = ", "), "\n")
  if (length(missing_txts) > 0) cat("Нет текстов для:", paste(missing_txts, collapse = ", "), "\n")
}

# --- Считываем эталоны ---
texts <- map_chr(text_paths, ~ readLines(.x, encoding = "UTF-8") |> paste(collapse = " "))

# --- Регистрируем модели ---
engine_rus <- tesseract("rus")
engine_orus <- tesseract("orus", datapath = "/Users/anastasiabogdanova/R_directory/Iskra_ocr")

# --- OCR для тестовых изображений ---
test_data <- tibble(
  image_path = images,
  truth = texts,
  rus = map_chr(images, ~ tesseract::ocr(.x, engine = engine_rus) |> trimws()),
  orus = map_chr(images, ~ tesseract::ocr(.x, engine = engine_orus) |> trimws())
)

# --- Нормализация текста ---
test_data_norm <- test_data |>
  mutate(across(c(truth, rus, orus), ~ tolower(.x))) |>
  mutate(across(c(truth, rus, orus), ~ str_remove_all(.x, "[[:punct:]|<>]")))

# --- Оценка точности на уровне "слов" (строк) ---
word_stats_rus <- test_data_norm |>
  mutate(rus_true = truth == rus) |>
  summarise(true_share = mean(rus_true, na.rm = TRUE))

word_stats_orus <- test_data_norm |>
  mutate(orus_true = truth == orus) |>
  summarise(true_share = mean(orus_true, na.rm = TRUE))

cat("\n=== Word-level accuracy ===\n")
cat("rus model:", round(word_stats_rus$true_share * 100, 2), "%\n")
cat("orus model:", round(word_stats_orus$true_share * 100, 2), "%\n")

# --- Символьные расстояния и CER ---
char_stats_orus <- test_data_norm |>
  mutate(
    len = nchar(truth),
    orus_ed = stringdist(truth, orus, method = "lv"),
    cer_row = orus_ed / pmax(len, 1)
  )

# Micro-CER
cer_micro <- sum(char_stats_orus$orus_ed) / sum(char_stats_orus$len)
# Macro-CER
cer_macro <- mean(char_stats_orus$cer_row)
# Accuracy
char_accuracy <- 1 - cer_micro

cat("\n=== Character-level metrics (orus model) ===\n")
cat("Micro-CER:", round(cer_micro * 100, 2), "%\n")
cat("Macro-CER:", round(cer_macro * 100, 2), "%\n")
cat("Character Accuracy:", round(char_accuracy * 100, 2), "%\n")

# --- Сохранение ---
results_path <- file.path(test_dir, "test_metrics_orus.csv")

write_csv(
  tibble(
    micro_CER = cer_micro,
    macro_CER = cer_macro,
    char_accuracy = char_accuracy,
    word_acc_rus = word_stats_rus$true_share,
    word_acc_orus = word_stats_orus$true_share
  ),
  results_path
)

cat("\n✅ Метрики сохранены в:", results_path, "\n")


# === Таблица с результатами ===

results_table <- tibble(
  Metric = c("Micro-CER", "Macro-CER", "Character Accuracy", 
             "Word Accuracy (rus)", "Word Accuracy (orus)"),
  Value = c(
    sprintf("%.2f %%", cer_micro * 100),
    sprintf("%.2f %%", cer_macro * 100),
    sprintf("%.2f %%", char_accuracy * 100),
    sprintf("%.2f %%", word_stats_rus$true_share * 100),
    sprintf("%.2f %%", word_stats_orus$true_share * 100)
  ),
  Description = c(
    "Average character error across the corpus",
    "Average character error per line",
    "Proportion of correctly recognized characters",
    "Proportion of perfectly recognized lines using rus model",
    "Proportion of perfectly recognized lines using fine-tuned orus model"
  )
)

cat("\n=== Summary Table ===\n")
print(results_table)

# сохранить таблицу в CSV
write_csv(results_table, file.path(test_dir, "test_metrics_table.csv"))
cat("\n📊 Таблица сохранена в:", file.path(test_dir, "test_metrics_table.csv"), "\n")
