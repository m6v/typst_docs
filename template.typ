// Глобальный счетчик для сквозных списков
#let enum-counter = counter("enum-counter")
// Счетчик приложений к документу
#let appendix-counter = counter("appendix-counter")

#let appendix-letters = ("А", "Б", "В", "Г", "Д", "Е", "Ж", "И", "К", "Л", "М", "Н", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ш", "Щ", "Э", "Ю", "Я")

// Динамическая нумерация таблиц и рисунков в зависимости от расположения (основная часть или в приложение)
#let figure-numbering(..args) = context {
  let appendix-number = appendix-counter.get().first()
  let figure-number = args.pos().first()

  // Если приложение вставить букву и номер, например, А.1, иначе только номер
  if appendix-number > 0 {
    let appendix-letter = appendix-letters.at(appendix-number - 1)
    [#appendix-letter.#str(figure-number)]
  } else {
    str(figure-number)
  }
}

// Оформление перечня обозначений и сокращений по ГОСТ 7.32—2017, на который ссылается п.6.1.2 ГОСТ Р 2.105—2019 
#let abbreviations(..items) = {
  // Автоматический перенос на новую страницу перед разделом
  pagebreak(weak: true)
  
  // Вывод заголовка первого уровня без нумерации и включения в оглавление документа
  heading(level: 1, numbering: none, outlined: false)[Обозначения и сокращения]

  // Стандартная вводная фраза по ГОСТ
  [В настоящем документе применяют следующие сокращения и обозначения:] 
  
  // Отступ перед таблицей сокращений
  v(12pt)
  
  grid(
    columns: (auto, 2em, 1fr),
    row-gutter: 1.2em,
    align: (left + top, center + top, left + top),
    ..for item in items.pos() {
      let parts = str(item).split(regex("\\s+[-—–]\\s+"))
      
      if parts.len() >= 2 {
        // Берем элементы напрямую из массива по индексам [0] и [1]
        (parts.at(0), [—], parts.at(1))
      } else {
        (item, [], [])
      }
    }
  )
}


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

// Вывод титульной страницы
#let title-page(doc-id: "", classification: (), title-lines: ()) = {
  // Фиксация шрифтов и размеров для титульного листа
  set text(font: "Liberation Serif", size: 14pt, lang: "ru")
  
  if classification.len() > 0 {
    place(
      top + right,
      dx: 0cm,    
      dy: -1.5cm,
      block(width: auto)[
        #set par(leading: 0.65em, first-line-indent: 0cm)
        #classification.join([\ ])
      ]
    )
  }

  align(left)[
    #set par(first-line-indent: 0cm)
    #v(1em) 
    УТВЕРЖДЕН \
    #if doc-id != "" [#doc-id;-ЛУ]
  ]

  if title-lines.len() > 0 {
    place(
      top + left,
      dx: 0cm,    
      dy: 7cm,
      block(width: 100%)[
        #align(center)[
          #set par(first-line-indent: 0cm)
          #title-lines.join([\ ]) \
          #doc-id \
          Листов #context counter(page).final().at(0)
        ]
      ]
    )
  }
}


// Вывод содержания
#let contents() = {
  pagebreak(weak: true)

  align(center)[
    // Вывод заголовка первого уровня без нумерации и включения в оглавление документа
    #heading(level: 1, numbering: none, outlined: false)[Содержание]
  ]

  // Удаление переносов строк (linebreak) внутри элементов оглавления
  show outline.entry: it => {
    show linebreak: " "
    it
  }

  outline(
    title: none,
    indent: 1.25cm,
    depth: 2 
  )
}


// Оформление приложения по ГОСТ 2.105-2019 / ГОСТ 2.503-2013
#let appendix(title, status: "обязательное", name: none) = {
  appendix-counter.step()

  // Сброс нумерации таблиц и рисунков внутри текущего приложения
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)

  pagebreak(weak: true)

  context {
    let num = appendix-counter.get().first()
    let appendix-letter = appendix-letters.at(num - 1)

    align(center)[
      #show heading: it => {
        set text(size: 14pt, weight: "bold")
        block(width: 100%)[#it.body]
      }
      
      #heading(level: 1, numbering: none)[
        Приложение #appendix-letter \
        #text[(#status)] \
        #title
      ]
    ]

    if name != none {
      [#metadata(appendix-letter) #label(name)]
    }
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


// Изменение нумерации списка (по умолчанию сброс на 1)
#let reset-enum(to: 1) = {
  // Установка значения на единицу меньше, так как первый плюс (+) сделает шаг вперед
  enum-counter.update(to - 1)
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

// Определение стилей
#let doc-style(doc-id: "", body) = {
  // Настройки текста и параграфов
  set text(
    font: "Liberation Serif", 
    size: 14pt, 
    lang: "ru",
    hyphenate: false
  )

  set smartquote(enabled: false)

  set par(
    leading: 1em,
    justify: true, 
    first-line-indent: (amount: 1.25cm, all: true)
  )


  // Настройки заголовков
  set heading(numbering: "1.1")
  show heading: set block(above: 24pt, below: 24pt)
  show heading: it => {
    set text(size: 14pt, weight: if it.level == 1 { "bold" } else { "regular" })
    
    // Сборка номера в переменную и возврат пустой строки, если номера нет
    let num = if it.numbering != none {
      context counter(heading).display(it.numbering) + h(0.5em)
    } else {
      ""
    }
    // Рендеринг заголовка
    block(width: 100%)[
      #h(1.25cm)#num#it.body
    ]
  }
  // Вывод заголовов первого уровня с новой страницы
  show heading.where(level: 1): it => pagebreak(weak: true) + it
  
  // Настройки ссылок с разделением счётчиков таблиц и рисунков
  show ref: it => {
    let el = it.element
    if el != none {
      // Проверка, есть ли у элемента поле "kind" (это рисунок или таблица)
      if el.has("kind") {
        // Извлечение счётчик именно для этого типа (image или table)
        let loc = el.location()
        let num = numbering(el.numbering, ..counter(figure.where(kind: el.kind)).at(loc))
        
        // Создание кликабельной ссылки с правильным номером
        link(loc, num)
      } else {
        // Если это ссылка на раздел (heading) или формулу
        link(el.location(), numbering(el.numbering, ..counter(el.func()).at(el.location())))
      }
    } else {
      it
    }
  }

  // Общие настройки для подписей таблиц и рисунков
  set figure.caption(separator: [ — ])

  // Подключение кастомного нумератора таблиц и рисунков
  set figure(numbering: figure-numbering)

  // Настройка подписей рисунков
  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.caption.where(kind: image): set align(center)
  
  // Настройка подписей таблиц
  show figure.where(kind: table): set figure(supplement: [Таблица])
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption.where(kind: table): set align(left)
  show figure.caption.where(kind: table): set par(first-line-indent: (amount: 0cm, all: false))
  show figure.where(kind: table): set block(breakable: true, sticky: true)

  // Настройки маркированных и нумерованных списков
  set list(marker: none, indent: 0pt, body-indent: 0pt)

  show list.item: it => block(width: 100%)[
    #set par(first-line-indent: (amount: 0cm, all: true))
    #h(1.25cm)-#h(0.5em, weak: true)#it.body
  ]
 
   // Вывод нумерованного списка с поддержкой сквозного счетчика
  show enum: it => {
    let start-num = enum-counter.get().first() + 1
    
    it.children.enumerate().map(((index, item)) => {
      let current-num = start-num + index
      block(width: 100%)[
        #set par(first-line-indent: (amount: 1.25cm, all: false))
        #h(1.25cm)#str(current-num)\)#h(0.5em, weak: true)#item.body
      ]
    }).join()
    
    // Обновление глобального счетчика нумерованных списков
    enum-counter.update(i => i + it.children.len())
  }

  // Настройки таблиц и ячеек
  show table: set text(size: 12pt)
  show table: set par(leading: 0.65em, justify: false, first-line-indent: (amount: 0cm, all: false))
  show table: set table(
    align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
    stroke: 0.5pt + black,
    inset: (left: 3pt, right: 5pt, y: 5pt) 
  )

  // Удаление внутри таблицы отступов списков
  show table: it => {
    // Маркированный список
    show list.item: item-it => block(width: 100%)[
      #set par(first-line-indent: (amount: 0cm, all: true))
      -#h(0.5em, weak: true)#item-it.body
    ]
    
    // Нумерованный список с поддержкой сквозного счетчика
    show enum: enum-it => {
      let start-num = enum-counter.get().first() + 1
      enum-it.children.enumerate().map(((index, item)) => {
        let current-num = start-num + index
        block(width: 100%)[
          #str(current-num)\)#h(0.5em, weak: true)#item.body
        ]
      }).join()
      enum-counter.update(i => i + enum-it.children.len())
    }

    it
  }

  // Настройки страницы и бокового штампа (ЕCПД)
  set page(
    paper: "a4",
    margin: (left: 2.5cm, right: 1.5cm, top: 2cm, bottom: 2cm),
    
    // Верхний колонтитул добавлять со второй страницы
    header: context {
      let page-num = counter(page).get().first()
      if page-num > 1 {
        align(right)[#doc-id С. #page-num]
      }
    },

    background: context {
      let page-num = counter(page).get().first()
      
      set text(
        font: "Liberation Serif", 
        size: 6.5pt, 
        tracking: -0.03em, 
        fill: black
      )
      set par(leading: 0.25em, first-line-indent: (amount: 0cm, all: false))
      
      if page-num == 1 {
        // Штамп первой страницы
        place(
          left + bottom, 
          dx: 0.5cm,     
          dy: -0.5cm,    
          rotate(-90deg, reflow: true)[
            #table(
              columns: (2.5cm, 3.5cm, 2.5cm, 2.5cm, 3.5cm, 5cm), 
              rows: (0.5cm, 0.5cm),               
              align: left + horizon,
              inset: (left: 4pt, right: 2pt, y: 0pt), 
              stroke: (col, row) => if col == 5 { none } else { 1pt + black },
              [Инв. № подл.], [Подп. и дата], [Взам. инв. №], [Инв. № дубл.], [Подп. и дата], [Разраб.],
              [], [], [], [], [], [Н.Контр]
            )
          ]
        )
      } else {
        // Штамп последующих страниц
        place(
          left + bottom, 
          dx: 0.5cm,     
          dy: -0.5cm, 
          rotate(-90deg, reflow: true)[
            #table(
              columns: (2.5cm, 3.5cm, 2.5cm, 2.5cm, 3.5cm), 
              rows: (0.5cm, 0.5cm),               
              align: left + horizon,
              inset: (left: 4pt, right: 2pt, y: 0pt), 
              stroke: 1pt + black,
              [Инв. № подл.], [Подп. и дата], [Взам. инв. №], [Инв. № дубл.], [Подп. и дата],
              [], [], [], [], []
            )
          ]
        )
      }
    }
  )

  // Настройки блока кода (с левой цветной полосой для всех типов кроме исключений) 
  show raw.where(block: true): it => {
    // Список языков/типов, для которых не нужна полоса
    let is-plain = it.lang in ("text", "console", "test", none)

    block(
      fill: rgb("#f3f4f6"),
      stroke: if is-plain { none } else { (left: 3pt + rgb("#2563eb")) },
      radius: if is-plain { 4pt } else { (right: 4pt) },
      inset: (x: 12pt, y: 10pt),
      width: 100%,
      text(font: "DejaVu Sans Mono", size: 0.85em, it)
    )
  }

  // Передаем основной документ
  body
}


// Лист регистрации изменений по ГОСТ 2.503-2013 Приложение В
#let change-log-page() = {
  page(
    margin: (top: 15mm, left: 15mm, right: 15mm, bottom: 5mm),
    [
      #set text(
        font: "Liberation Serif", 
        size: 7.5pt,              
        tracking: -0.03em         
      )
      #set par(leading: 0.35em, first-line-indent: (amount: 0cm, all: false))
      #show table.cell: set par(first-line-indent: (amount: 0cm, all: false))
      #set table(inset: (x: 2pt, y: 3pt))

      #block(
        width: 100%,
        height: 100%,
        table(
          columns: (10mm, 17mm, 17mm, 17mm, 17mm, 23mm, 20mm, 35mm, 15mm, 15mm),
          rows: (auto, auto, auto, ..(1fr,) * 30),
          align: center + horizon,
          stroke: 0.5pt + black,

          table.header(
            table.cell(colspan: 10)[Лист регистрации изменений],
            table.cell(rowspan: 2)[Изм.], table.cell(colspan: 4)[Номера листов (страниц)], table.cell(rowspan: 2)[Всего листов\ (страниц)\ в документе], table.cell(rowspan: 2)[Номер\ доку-\ мента], table.cell(rowspan: 2)[Входящий номер\ сопроводительного\ документа и дата], table.cell(rowspan: 2)[Под-\ пись], table.cell(rowspan: 2)[Дата],
            [изменен-\ ных], [заменен-\ ных], [новых], [аннулиро-\ ванных],
            table.hline(y: 3, stroke: 1.2pt + black)
          ),
        )
      )
    ]
  )
}

#let template = (
  appendix:appendix,
  aref:aref,
  change-log-page: change-log-page,
  contents: contents,
  doc-style: doc-style,
  formatted-table: formatted-table,
  reset-enum: reset-enum,
  title-page: title-page,
)
