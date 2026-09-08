#import "template.typ": doc-style, title-page, contents, appendix, change-log-page

#let doc-id = "ТХШИ.466453.001"

//Применение стилей оформления
#show: doc-style.with(doc-id: doc-id)

//Титульный лист
#title-page(
  doc-id: doc-id,
  classification: (
    [#underline[Для общего пользования]],
    "Экз. 1",
    "(п. 007 Перечня сведений ВС)"
  ),
  title-lines: (
    "Система защиты информации УТЦ",
    "Руководство администратора",
    "Часть 1",
    "Руководство по комплексу средств защиты информации"
  )
)

//Содержание
#contents()

//Список сокращений
#include "abbreviations.typ"

//Основная часть
#include "section_1.typ"
#include "section_2.typ"
#include "section_3.typ"
#include "section_4.typ"
#include "section_5.typ"

//Приложения
#counter(heading).update(0) 
#appendix("Контрольный пример настроек средств защиты информации")
#include "appendix_a.typ"
#appendix("Матрица доступа", status: "рекомендуемое", name: "matrix")
#include "appendix_b.typ"

//Лист регистрации изменений
#change-log-page()
