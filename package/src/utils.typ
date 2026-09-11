
#let appendix-letters = ("А", "Б", "В", "Г", "Д", "Е", "Ж", "И", "К", "Л", "М", "Н", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ш", "Щ", "Э", "Ю", "Я")

// Глобальный счетчик для сквозных списков
#let enum-counter = counter("enum-counter")
// Счетчик приложений к документу
#let appendix-counter = counter("appendix-counter")


// Динамическая нумерация таблиц и рисунков в зависимости от расположения (основная часть или в приложение)
#let figure-numbering(..args) = context {
  let appendix-number = appendix-counter.get().first()
  let figure-number = args.pos().first()

  // Если приложение - вставить букву и номер, например, А.1, иначе - только номер
  if appendix-number > 0 {
    let appendix-letter = appendix-letters.at(appendix-number - 1)
    [#appendix-letter.#str(figure-number)]
  } else {
    str(figure-number)
  }
}

// Вставка ссылок на приложения
#let aref(name) = context {
  let matches = query(label(name))
  if matches.len() > 0 {
    matches.first().value
  } else {
    [*Error! Reference source not found for "#name"*]
  }
}


// Вставка иконок в текст
#let icon(path) = box(
  baseline: 15%,   // выравнивание по нижней линии шрифта
  height: 0.9em,   // подстраивание размера под высоту текущего текста
  inset: (x: 2pt), // отступы 2pt слева и справа
  image(path)
)


// Вывод примечаний
#let note(..items) = {
  let pos-items = items.pos()
  if pos-items.len() == 0 { return }
  
  let note-indent = 1.25cm
  
  block(width: 100%, inset: (y: 0.2em))[
    // Отключение абзацного отступа, чтобы не суммировался с #h(1.25cm)
    #set par(first-line-indent: (amount: 0cm, all: false))
    #set text(size: 12pt)
    
    //Разное оформление в зависимости от того одно или несколько примечаний
    #if pos-items.len() == 1 [
      #h(note-indent)#text(tracking: 0.2em)[Примечание] — #pos-items.at(0)
    ] else [
      #h(note-indent)#text(tracking: 0.2em)[Примечания]
      
      #pos-items.enumerate().map(((i, item)) => [
        #h(note-indent)#(i + 1) #item
      ]).join([\ ])
    ]
  ]
}

// Изменение нумерации списка (по умолчанию сброс на 1)
#let reset-enum(to: 1) = {
  // Установка значения на единицу меньше, так как первый плюс (+) сделает шаг вперед
  enum-counter.update(to - 1)
}

// Вывод абзацев без отступа первой строки
#let no-indent(body) = {
  set par(first-line-indent: 0pt)
  body
}

// Обертка для таблиц с автоматической жирной чертой под шапкой
#let formatted-table(
  header: (),
  columns: none,
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
  ..args
) = {
  // Автоматически делаем элементы шапки жирными, если переданы обычные строки/содержимое
  let formatted-header = header.map(strong)

  table(
    columns: columns,
    align: align,
    table.header(
      repeat: true,
      ..formatted-header,
      table.hline(stroke: 1.5pt + black),
    ),
    ..args
  )
}


