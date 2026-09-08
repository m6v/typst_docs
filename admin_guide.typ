#import "template.typ": guide, title-page, contents, appendix, change-log-page

#let doc-id = "ТХШИ.466453.001"

#show: guide.with(doc-id: doc-id)

// 2. Вручную вызываем титульный лист прямо в потоке документа
#title-page(
  doc-id: doc-id,
  classification: (
    "Для общего пользования",
    "Экз. 1",
    "(п. 007 Перечня ВС)"
  ),
  title-lines: (
    "Система защиты информации УТЦ",
    "Руководство администратора",
    "Часть 1",
    "Руководство по комплексу средств защиты информации"
  )
)

#contents()

#include "abbreviations.typ"

#include "section_1.typ"
#include "section_2.typ"
#include "section_3.typ"
#include "section_4.typ"
#include "section_5.typ"

#counter(heading).update(0) 
#appendix("Контрольный пример настроек средств защиты информации")
#include "appendix_a.typ"
#appendix("Исходный код модуля управления", status: "рекомендуемое")
#include "appendix_b.typ"

#change-log-page()
