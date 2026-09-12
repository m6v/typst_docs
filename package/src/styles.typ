#import "utils.typ": enum-counter

// Константы и глобальное состояние для приложений
#let appendix-letters = ("А", "Б", "В", "Г", "Д", "Е", "Ж", "И", "К", "Л", "М", "Н", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ш", "Щ", "Э", "Ю", "Я")
#let appendix-counter = counter("appendix")

// Оформление перечня обозначений и сокращений по ГОСТ 7.32—2017, на который ссылается п.6.1.2 ГОСТ Р 2.105—2019 
#let abbreviations(..items) = {
  // Автоматический перенос на новую страницу перед разделом
  pagebreak(weak: true)
  
  // Вывод заголовка первого уровня без нумерации и включения в оглавление документа
  heading(level: 1, numbering: none, outlined: false)[Обозначения и сокращения]

  // Вводная фраза по ГОСТ
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


// Вывод титульной страницы
#let titlepage(doc-id: "", classification: (), title-lines: ()) = {
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

// Лист регистрации изменений по ГОСТ 2.503-2013 Приложение В
#let changelog() = {
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


// Функция вызывается генерации номеров приложений (в тексте и оглавлении)
#let appendix-numbering(..args) = {
  let nums = args.pos()
  if nums.len() == 1 {
    let letter = appendix-letters.at(nums.first() - 1)
    [Приложение #letter]
  } else {
    let letter = appendix-letters.at(nums.first() - 1)
    let sub-nums = nums.slice(1).map(str).join(".")
    [#letter.#sub-nums]
  }
}

// Шоу-правило, которое меняет схему нумерации и сбрасывает счетчики
#let appendixes(body) = {
  set heading(numbering: appendix-numbering)
  
  // Сброс системных счетчиков
  counter(heading).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  
  body
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

  // Настройка заголовков для основной части документа
  set heading(numbering: "1.1")
  show heading: set block(above: 24pt, below: 24pt)
  
  // Единое правило отображения заголовков (управляет внешним видом)
  show heading: it => {
    set text(size: 14pt)
    
    if it.level == 1 {
      // Для первого уровня (и глав, и приложений) делаем разрыв страницы
      pagebreak(weak: true)
      
      // Проверяем, какой паттерн нумерации сейчас активен в документе
      if it.numbering == appendix-numbering {
        // Оформление Приложений (по центру, без абзацного отступа)
        align(center)[
          #set text(weight: "bold")
          #set par(first-line-indent: 0cm)
          // Нативный вывод номера ("Приложение А")
          #context counter(heading).display(it.numbering) \
          // Название приложения
          #it.body
        ]
      } else {
        // Оформление заголовкоа уровня 1 (жирный, с абзацным отступом)
        block(width: 100%)[
          #set text(weight: "bold")
          #h(1.25cm)
          #if it.numbering != none { 
            context counter(heading).display(it.numbering)
            h(0.5em) 
          }
          #it.body
        ]
      }
    } else {
      // Оформление для заголовков уровня 2 и ниже
      block(width: 100%)[
        #set text(weight: "regular")
        #h(1.25cm)
        #if it.numbering != none { 
          context counter(heading).display(it.numbering)
          h(0.5em) 
        }
        #it.body
      ]
    }
  }

  // Настройки ссылок с разделением счётчиков таблиц и рисунков
  show ref: it => {
    let el = it.element
    if el != none {
      context {
        // 1. Проверяем, ведет ли ссылка на заголовок приложения 1-го уровня
        if el.func() == heading and el.level == 1 and el.numbering == appendix-numbering {
          let heading-nums = counter(heading).at(el.location())
          if heading-nums.len() > 0 {
            let letter = appendix-letters.at(heading-nums.first() - 1)
            return link(el.location(), letter) // Возвращаем только букву
          }
        }
        
        // Обработка ссылок на рисунки и таблицы
        if el.has("kind") {
          let loc = el.location()
          let num = numbering(el.numbering, ..counter(figure.where(kind: el.kind)).at(loc))
          link(loc, num)
        } else {
          // Обработка ссылок на обычные заголовки и  формулы
          link(el.location(), numbering(el.numbering, ..counter(el.func()).at(el.location())))
        }
      }
    } else {
      it
    }
  }

  // Общие настройки для подписей таблиц и рисунков
  set figure.caption(separator: [ — ])

  // Динамическая нумерация рисунков и таблиц по ГОСТ (учитывает обычные главы и приложения)
  set figure(numbering: (..args) => context {
    let heading-nums = counter(heading).get()
    let fig-num = args.pos().first()
    
    // Проверяем, включен ли сейчас режим нумерации приложений
    if heading-nums.len() > 0 and heading.numbering == appendix-numbering {
      let letter = appendix-letters.at(heading-nums.first() - 1)
      [#letter.#fig-num]
    } else {
      // Стандартная нумерация для основного текста
      str(fig-num) 
    }
  })

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
    show list.item: item-it => block(width: 100%)[
      #set par(first-line-indent: (amount: 0cm, all: true))
      -#h(0.5em, weak: true)#item-it.body
    ]
    
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
    
    header: context {
      let page-num = counter(page).get().first()
      if page-num > 1 {
        align(right)[#doc-id С. #page-num]
      }
    },

    background: context {
      let page-num = counter(page).get().first()
      
      set text(font: "Liberation Serif", size: 6.5pt, tracking: -0.03em, fill: black)
      set par(leading: 0.25em, first-line-indent: (amount: 0cm, all: false))
      
      if page-num == 1 {
        place(
          left + bottom, dx: 0.5cm, dy: -0.5cm,    
          rotate(-90deg, reflow: true)[
            #table(
              columns: (2.5cm, 3.5cm, 2.5cm, 2.5cm, 3.5cm, 5cm), rows: (0.5cm, 0.5cm),               
              align: left + horizon, inset: (left: 4pt, right: 2pt, y: 0pt), 
              stroke: (col, row) => if col == 5 { none } else { 1pt + black },
              [Инв. № подл.], [Подп. и дата], [Взам. инв. №], [Инв. № дубл.], [Подп. и дата], [Разраб.],
              [], [], [], [], [], [Н.Контр]
            )
          ]
        )
      } else {
        place(
          left + bottom, dx: 0.5cm, dy: -0.5cm, 
          rotate(-90deg, reflow: true)[
            #table(
              columns: (2.5cm, 3.5cm, 2.5cm, 2.5cm, 3.5cm), rows: (0.5cm, 0.5cm),               
              align: left + horizon, inset: (left: 4pt, right: 2pt, y: 0pt), stroke: 1pt + black,
              [Инв. № подл.], [Подп. и дата], [Взам. инв. №], [Инв. № дубл.], [Подп. и дата],
              [], [], [], [], []
            )
          ]
        )
      }
    }
  )

  // Настройки блока кода (с левой цветной полосой)
  show raw.where(block: true): it => {
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

  body
}
