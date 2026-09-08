// Функция для оформления списка сокращений (по ГОСТ 7.32—2017, на который ссылается ГОСТ Р 2.105—2019 п.6.1.2)
#let abbreviations(..items) = {
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

#let note(..items) = {
  let pos-items = items.pos()
  let note-indent = 1.25cm
  let item-spacing = 0em // Компактный интервал между пунктами
  
  block(
    width: 100%,
    inset: (y: 0.2em),
    text(size: 12pt)[
      #if pos-items.len() == 1 [
        #h(note-indent)#text(tracking: 0.2em)[Примечание] — #pos-items.at(0)
      ] else [
        #h(note-indent)#text(tracking: 0.2em)[Примечания]
        
        #for (i, item) in pos-items.enumerate() {
          v(item-spacing)
          [#(i + 1) #item]
        }
      ]
    ]
  )
}


#let make-title-page(doc-id, classification, title-lines) = {
  // Настройки текста и абзацев для титульной страницы (размер 14pt)
  set text(font: "Liberation Serif", size: 14pt, lang: "ru")
  
  // Блок классификации (вверху справа)
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

  // Блок утверждения (слева)
  align(left)[
    #set par(first-line-indent: 0cm)
    #v(1em) 
    УТВЕРЖДЕН \
    #if doc-id != "" [#doc-id;-ЛУ]
  ]

  // Блок по центру (название документа)
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
    
    // Автоматический перенос на следующую страницу
    pagebreak()
  }
}


#let guide(doc-id: "", classification: (), title-lines: (), body) = {


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
  show heading: pad.with(left: 1.25cm)
  show heading: it => {
    set text(size: 14pt, weight: if it.level == 1 { "bold" } else { "regular" })
    it
  }
  show heading.where(level: 1): it => pagebreak(weak: true) + it

  // Настройки ссылок
  show ref: it => if it.element != none { 
    link(it.element.location(), numbering(it.element.numbering, ..counter(it.element.func()).at(it.element.location()))) 
  } else { it }

  // Настройки оглавления
  show outline.entry: it => {
    show linebreak: [ ]
    it
  }

  // Настройки таблиц и рисунков
  show figure.where(kind: table): set figure.caption(
    separator: " — ", 
    position: top     
  )
  show figure.caption.where(kind: table): set align(left)
  show figure.caption.where(kind: table): set par(first-line-indent: (amount: 0cm, all: false))
  show figure.where(kind: table): set block(breakable: true, sticky: true)

  // Настройки маркированных и нумерованных списков
  set list(marker: none, indent: 0pt, body-indent: 0pt)

  show list.item: it => block(width: 100%)[
    #set par(first-line-indent: (amount: 0cm, all: true))
    #h(1.25cm)-#h(0.5em, weak: true)#it.body
  ]

  // Вывод нумерованного списка через map().join()
  show enum: it => {
    let start-num = if it.start != auto { it.start } else { 1 }
    it.children.enumerate().map(((index, item)) => {
      let current-num = start-num + index
      block(width: 100%)[
        #set par(first-line-indent: (amount: 1.25cm, all: false))
        #h(1.25cm)#str(current-num)\)#h(0.5em, weak: true)#item.body
      ]
    }).join()
  }

  // Настройки таблиц и ячеек
  show table: set text(size: 12pt)
  show table: set par(leading: 0.65em, justify: false, first-line-indent: (amount: 0cm, all: false))
  show table: set table(
    align: (col, row) => if row == 0 { center + horizon } else { left + horizon }
  )

  // Сброс оформления списков внутри ячеек таблиц
  show table.cell: it => {
    set par(first-line-indent: (amount: 0cm, all: false))
    show list.item: item-it => [
      #set text(size: 12pt)
      #set par(first-line-indent: (amount: 0cm, all: false))
      \- #item-it.body 
    ]
    show enum.item: enum-it => [
      #set text(size: 12pt)
      #set par(first-line-indent: (amount: 0cm, all: false))
      #enum-it.body
    ]
    it
  }

  // Настройки страницы и бокового штампа (ЕCПД)
  set page(
    paper: "a4",
    margin: (left: 3.5cm, right: 1.5cm, top: 2cm, bottom: 2cm),
    
    // МИКРО-ДОБАВЛЕНИЕ: Верхний колонтитул со 2-й страницы
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

  make-title-page(doc-id, classification, title-lines)

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

// Счетчик для приложений к документу
#let appendix-counter = counter("appendices")

// Функция приложения по ГОСТ 2.105-2019
#let appendix(title, status: "обязательное") = {
  appendix-counter.step()
  
  // Разрыв страницы на верхнем уровне документа
  pagebreak(weak: true)
  
  context {
    let num = appendix-counter.get().first()
    let ru-letters = ("А", "Б", "В", "Г", "Д", "Е", "Ж", "И", "К", "Л", "М", "Н", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ш", "Щ", "Э", "Ю", "Я")
    let app-letter = ru-letters.at(num - 1)
    
    // Сброс счетчиков рисунков и таблиц под контекст приложения
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    
    // Оформляем центрированный заголовок приложения через чистый text/block
    align(center)[
      #block(width: 100%, below: 1.5em)[
        #set par(first-line-indent: 0pt)
        
        #text(weight: "bold", size: 1.2em)[Приложение #app-letter]
        
        #v(0.4em)
        #text(weight: "regular", size: 0.9em)[(#status)]
        
        #v(0.6em)
        #text(weight: "bold", size: 1.1em)[#title]
      ]
    ]
  }
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

