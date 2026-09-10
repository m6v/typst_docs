#import "template.typ": reset-enum, formatted-table

#let rows = csv("matrix.csv", delimiter: ";")

#figure(
  caption: [Тестовая таблица для проверки списков и шрифтов],

  formatted-table(
    // Настройка колонок: автоматическая ширина по контенту
    columns: (1fr, 1fr, 1fr),
    
    // Выравнивание: шапка по центру, данные по левому краю
    align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
    
    // Фиксируем шапку при переносе таблицы на новую страницу
    header: ("ФИО", "Должность", "Оклад"),
  
    // Вставляем строки из CSV-файла
    ..rows.flatten()
  )

) <test1>

