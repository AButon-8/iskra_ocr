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

## Результаты
Метрики распознавания дореформенных текстов

Micro-CER: 1.94 %
Средняя доля ошибочных символов по всему корпусу.

Macro-CER: 3.09 %
Средняя доля ошибок по отдельным строкам.

Character Accuracy: 98.06 %
Процент правильно распознанных символов.

Эти показатели демонстрируют, что дообученная модель значительно повышает качество распознавания по сравнению со стандартной моделью rus для дореформенной орфографии.

---

## Acknowledgements

**Developer:** [locusclassicus](https://github.com/locusclassicus)
<br>
**Contributors:** The authors sincerely thank everyone who contributed to the project. Special thanks are extended to Anastasia Orlova for her comprehensive support and assistance, and to the students of the Master's program "Russian Literature and Comparative Studies" — Darya Bakharskaya, Aynur Gasanova, Ekaterina Gureeva, Natalia Luzganova, Ekaterina Mozharovskaya, Polina Trofimova, and Elina Chinkina — for their help in preparing the reference data.


## License

This repository is released under the **Apache License 2.0**,  
the same open-source license used by the original Tesseract OCR project.  
You are free to use, modify, and distribute this model, provided that you include attribution to the original authors.

See the [LICENSE](./LICENSE) file for full details.