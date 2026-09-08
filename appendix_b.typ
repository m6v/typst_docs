Текст второго приложения

#figure(
  caption: [Тестовая таблица для проверки списков и шрифтов],
  table(
    columns: (1.5fr, 1fr, 2fr, 1fr, 1fr, 1fr, 1fr),
    stroke: 0.5pt + black,
    align: (center + top, center + top, center + top, center + top, center + top, center + top, center + top),  
    
    table.header(repeat: true,
      table.cell(rowspan: 2, align: center + horizon)[Субъект доступа (пользователь)],
      table.cell(rowspan: 2, align: center + horizon)[Первичная группа],
      table.cell(rowspan: 2, align: center + horizon)[Доп. группы],
      table.cell(colspan: 3, align: center + horizon)[Возможные значения мандатного контекста безопасности],
      table.cell(rowspan: 2, align: center + horizon)[Linux- и PARSEC-привилегии (usercaps)],
      
      table.cell( align: center + horizon)[Уровень конфиден-циаль-ности (мин.:макс.)],
      table.cell( align: center + horizon)[Уровень целост-ности (мин.: макс.)],
      table.cell(align: center + horizon)[Категория],
    ),

    [Администратор безопасности информации], [astra-admin],
    [video, scanner, plugdev, netdev, lpadmin, floppy, dip, cdrom, audio, astra-console, adm],
    [0:0], [Низкий:\ Высокий], [ - ], [0x0:0x0],

    [Инструктор], [instructors],
    [video, users, plugdev, floppy, dialout, cdrom, audio],
    [0:0], [Низкий:\ Высокий], [ - ], [0x0:0x0],

    [Обучаемый], [learners],
    [video, users, plugdev, floppy, dialout, cdrom, audio],
    [0:0], [Низкий:\ Высокий], [ - ], [0x0:0x0],
  )
) <test>
