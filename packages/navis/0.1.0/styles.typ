// Шаблон для оформления ЭД СЗИ УТЦ
#import "components/appendixes.typ": appendix-letters, appendix-numbering

// Глобальный счетчик для сквозных списков
#let enum-counter = counter("enum-counter")

#let text-document(doc-id: "", body) = {

  set page(
    paper: "a4",
    margin: (
      inside: 2.2cm,
      outside: 1.7cm,
      top: 3.0cm,
      bottom: 3.5cm,
    ),

    header: context {
      let page_num = counter(page).get().first()
      if page_num <= 2 { return none }

      let header_text = if calc.even(page_num) [
        #doc-id #h(1fr)
      ] else [
        #h(1fr) #doc-id
      ]

      block(width: 100%)[
        #set par(first-line-indent: 0pt)
        #v(1cm)
        #header_text
        #v(-0.2cm)
        #stack(
          spacing: 1.5pt,
          line(length: 100%, stroke: 0.5pt),
          line(length: 100%, stroke: 0.5pt),
        )
      ]
    },

    footer: context {
      let page_num = counter(page).get().first()
      if page_num <= 2 { return none }

      let footer_text = if calc.even(page_num) [
        #page_num #h(1fr) СЗИ УТЦ
      ] else [
        СЗИ УТЦ #h(1fr) #page_num
      ]

      block(width: 100%)[
        #set par(first-line-indent: 0pt)
        #stack(
          spacing: 1.5pt,
          line(length: 100%, stroke: 0.5pt),
          line(length: 100%, stroke: 0.5pt),
        )
        #v(-0.3cm)
        #footer_text
        #v(1cm)
      ]
    }
  )

   set text(
     font: "Liberation Serif",
     size: 13pt, 
     lang: "ru",
     hyphenate: false
   )

  // 2. Настройка абзацев текста (выравнивание по ширине и отступ)
  set par(
    justify: true,
    first-line-indent: (amount: 1.25cm, all: true),
  )

  // Включаем автоматическую нумерацию по типу 1.1
  set heading(numbering: "1.1")

  // Правило отображения заголовков
  show heading: it => {
    set text(size: 13pt)

    // Отступы заголовков
    let h1-below     = 12pt
    let h2-above     = 12pt
    let h2-below     = 12pt
    // Отступ между заголовком и наименованием приложения
    let appendix-gap = 12pt 
    // Межстрочный интервал в многострочном заголовке
    set par(leading: 0.65em)

    if it.level == 1 {
      pagebreak(weak: true)
      set text(size: 14pt)

      if it.numbering == appendix-numbering {
        // Оформление приложений к основной части
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
        // Оформление заголовков разделов (уровень 1) основной части
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
      // Оформление подразделов, пунктов и подпунктов (уровень 2 и ниже)
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

  // Настройка подписей рисунков
  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.caption.where(kind: image): set align(center)

  // Настройка подписей таблиц
  show figure.where(kind: table): set figure(supplement: [Таблица])
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption.where(kind: table): set align(left)
  show figure.caption.where(kind: table): set par(first-line-indent: (amount: 0cm, all: false))
  show figure.where(kind: table): set block(breakable: true, sticky: true)

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

  body
}
