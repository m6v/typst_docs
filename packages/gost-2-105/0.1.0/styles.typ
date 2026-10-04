#import "utils.typ": enum-counter
#import "components/appendixes.typ": appendix-letters, appendix-numbering

// Определение стилей
#let gost-document(doc-id: "", body) = {
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
    spacing: 1em,
    justify: true,
    first-line-indent: (amount: 1.25cm, all: true),
  )

  // Настройка нумерации заголовков
  set heading(numbering: "1.1")

  // Правило отображения заголовков
  show heading: it => {
    set text(size: 14pt)

    // Отступы заголовков
    let h1-below     = 24pt
    let h2-above     = 20pt
    let h2-below     = 12pt
    // Отступ между заголовком и наименованием приложения
    let appendix-gap = 12pt
    // Межстрочный интервал в многострочном заголовке
    set par(leading: 0.65em)

    if it.level == 1 {
      pagebreak(weak: true)

      if it.numbering == appendix-numbering {
        // Оформление приложений к основной части
        counter(figure.where(kind: image)).update(0)
        counter(figure.where(kind: table)).update(0)
        block(width: 100%, below: h1-below)[
          #align(center)[
            #set par(first-line-indent: 0cm)

            // Вывод строки с номером приложения
            #context counter(heading).display(it.numbering)

            // Вывод в скобках строки со статусом приложения из it.supplement
            #v(appendix-gap, weak: true)
            (#it.supplement)

            // Вывод наименования заголовка приложения
            #v(appendix-gap, weak: true)
            #it.body
          ]
        ]
      } else {
        // Оформление заголовков разделов (уровень 1)
        block(width: 100%, below: h1-below)[
          #h(1.25cm)
          #if it.numbering != none {
            context counter(heading).display(it.numbering)
            h(0.5em)
          }
          #it.body
        ]
      }
    } else {
      // Оформление заголовков подразделов, пунктов и подпунктов (уровень 2 и ниже)
      block(
        width: 100%,
        above: h2-above,
        below: h2-below
      )[
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
        // Обработка ссылок на приложения
        if el.func() == heading and el.level == 1 and el.numbering == appendix-numbering {
          let heading-nums = counter(heading).at(el.location())
          if heading-nums.len() > 0 {
            let letter = appendix-letters.at(heading-nums.first() - 1)
            return link(el.location(), letter)
          }
        }

        // Обработка ссылок на рисунки и таблицы
        if el.has("kind") {
          let loc = el.location()
          let num = numbering(el.numbering, ..counter(figure.where(kind: el.kind)).at(loc))
          link(loc, num)
        } else {
          // Обработка ссылок на обычные заголовки и формулы
          link(el.location(), numbering(el.numbering, ..counter(el.func()).at(el.location())))
        }
      }
    } else {
      it
    }
  }

  // Общие настройки для подписей таблиц и рисунков
  set figure.caption(separator: [ — ])

  // Динамическая нумерация рисунков и таблиц с учетом нахождения их в основной части или в приложениях
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

  // Удаление внутри таблицы отступов у маркированных и нумерованных списков
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
