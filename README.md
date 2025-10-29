## Fine-tuned Tesseract model for Russian pre-reform orthography
Fine-tuned on materials from the revolutionary social-democratic newspaper “Iskra” (1900–1905), printed in pre-reform Russian orthography.

## Repository Structure

```plaintext
iskra_ocr/
├── orus-ground-truth/     # Source images and ground-truth texts / Исходные изображения и эталонные тексты
├── r_scripts/             # R scripts for training and validation / Скрипты для обучения и валидации модели
├── orus.traineddata       # Fine-tuned Tesseract OCR model / Дообученная модель Tesseract
├── README.md              # Project description and metrics / Описание проекта и метрики
└── LICENSE                # License (Apache 2.0) / Лицензия
```

## Results

### OCR Performance on Pre-Reform Texts

| Metric                  | Value    | Description |
|--------------------------|---------|-------------|
| **Micro-CER**            | 1.94 %  | Average character error across the corpus |
| **Macro-CER**            | 3.09 %  | Average character error per line |
| **Character Accuracy**   | 98.06 % | Proportion of correctly recognized characters |

These results indicate a significant improvement over the standard `rus` model for pre-reform orthography.

### Training Progress

| Stage                  | BCER (%)      | BWER (%)      |
|------------------------|---------------|---------------|
| Initial iterations     | 22.5 – 28.1   | 41 – 54.5     |
| Mid checkpoints        | 4.2 – 5.4     | 8.6 – 10.6    |
| Final iterations       | 5.374         | 10.65         |

**Notes:**  
- **BCER** — Batch Character Error Rate  
- **BWER** — Batch Word Error Rate  
- The fine-tuning process demonstrates rapid reduction of both character- and word-level errors, with final checkpoints yielding a stable, high-accuracy model.


## Acknowledgements

**Developer:** [locusclassicus](https://github.com/locusclassicus)
<br>
**Contributors:** The authors sincerely thank everyone who contributed to the project. Special thanks are extended to *Anastasia Orlova* for her comprehensive support and assistance, and to the students of the Master's program "Russian Literature and Comparative Studies" — *Darya Bakharskaya, Aynur Gasanova, Ekaterina Gureeva, Natalia Luzganova, Ekaterina Mozharovskaya, Polina Trofimova, and Elina Chinkina* — for their help in preparing the reference data.


## License

This repository is released under the **Apache License 2.0**,  
the same open-source license used by the original Tesseract OCR project.  
You are free to use, modify, and distribute this model, provided that you include attribution to the original authors.

See the [LICENSE](./LICENSE) file for full details.