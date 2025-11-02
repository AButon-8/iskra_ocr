## Fine-tuned Tesseract model for Russian pre-reform orthography
Fine-tuned on materials from the revolutionary social-democratic newspaper “Iskra” (1900–1905), printed in pre-reform Russian orthography.

## Repository Structure

```plaintext
iskra_ocr/
├── data/                    # Datasets used for model training and validation / Наборы данных для обучения и валидации
│   ├── ground-truth/        # Ground-truth data / Эталонная разметка
│   └── val/                 # Validation dataset / Валидационная выборка
├── r_scripts/               # R scripts for training, validation, and test set processing / Скрипты для обучения, валидации и подготовки тестовой выборки модели
├── orus.traineddata         # Fine-tuned Tesseract OCR model / Дообученная модель Tesseract
├── orus_viz.jpg             # Sample from *Iskra* showing pre-1918 Russian letters / Пример текста из «Искры» с дореформенными буквами
├── README.md                # Project description and metrics / Описание проекта и метрики
└── LICENSE                  # License (Apache 2.0) / Лицензия
```




## Results

### OCR Performance on Pre-Reform Texts (Test Set)

| Model | Word Accuracy (%) | Micro-CER (%) | Macro-CER (%) | Char Accuracy (%) | WER (%) |
|-------|-----------------|---------------|---------------|------------------|---------|
| rus   | 61.2            | 9.45          | 13.0          | 90.6             | 69.9    |
| orus  | 94.0            | 1.30          | 2.35          | 98.7             | 9.9     |

These results indicate a significant improvement of the fine-tuned `orus` model over the standard `rus` model for pre-reform orthography.

### Training Progress

| Stage             | BCER (%)      | BWER (%)      |
|------------------|---------------|---------------|
| Initial iterations | 22.5 – 28.1  | 41 – 54.5     |
| Mid checkpoints   | 4.2 – 5.4    | 8.6 – 10.6    |
| Final iterations  | 5.374        | 10.65         |

**Notes:**

- BCER — Batch Character Error Rate  
- BWER — Batch Word Error Rate  

The fine-tuning process demonstrates rapid reduction of both character- and word-level errors, with final checkpoints yielding a stable, high-accuracy model.


## Acknowledgements

**Developers:** [locusclassicus](https://github.com/locusclassicus), [AButon-8](https://github.com/AButon-8)

**Project Contributors:** We are especially grateful to the students of the Master’s program *“Russian Literature and Comparative Studies”* at HSE University (Moscow), who participated in this project, for their collective contribution to the preparation of the reference data. In particular, we would like to thank *Darya Bakharskaya, Aynur Gasanova, Ekaterina Gureeva, Natalia Luzganova, Ekaterina Mozharovskaya, Polina Trofimova, and Elina Chinkina* for their especially significant work.

Special thanks are also extended to *Anastasia Orlova* for her comprehensive support and assistance.

**External Resources:** We would like to express our gratitude to [Andrés Cruz](https://andrescruz.org/posts/finetuning-tess/index.html) for sharing his documentation and example workflow on Tesseract model fine-tuning, which helped us configure the model installation.


## License

This repository is released under the **Apache License 2.0**,  
the same open-source license used by the original Tesseract OCR project.  
You are free to use, modify, and distribute this model, provided that you include attribution to the original authors.

See the [LICENSE](./LICENSE) file for full details.