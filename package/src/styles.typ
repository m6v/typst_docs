#import "utils.typ": enum-counter
#import "components/appendixes.typ": appendix-letters, appendix-numbering

// Определение стилей
#let text-document(doc-id: "", body) = {
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
