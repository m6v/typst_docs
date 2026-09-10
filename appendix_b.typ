
#let rows = csv("matrix.csv", delimiter: ";")

#let headers = ("ФИО", "Должность", "Оклад")

#figure(
  caption: [Тестовая таблица для проверки списков и шрифтов],

  table(
    // Настройка колонок: автоматическая ширина по контенту
    columns: (1fr,) * headers.len(),
    
    // Делаем красивую заливку для шапки (заголовка)
    fill: (col, row) => if row == 0 { rgb("e0e0e0") } else { none },
    
    // Выравнивание: шапка по центру, данные по левому краю
    align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
    
    // Фиксируем шапку при переносе таблицы на новую страницу
    table.header(
      ..headers.map(header => [*#header*]) // Делаем текст жирным
    ),
  
    // Вставляем строки из CSV-файла
    ..rows.flatten()
  )

) <test>
