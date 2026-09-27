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


  /////////////////////////////////////////////////////////////////////////////////////////



  // 1. Вспомогательная функция-предикат для определения ГОСТ-таблицы
  let is-gost-table(fig) = {
    fig.has("body") and fig.body.func() == grid and fig.body.fields().at("stroke", default: none) == 0.5pt
  }

  // 2. ВАШИ СУЩЕСТВУЮЩИЕ НАСТРОЙКИ ФИГУР
  set figure.caption(separator: [ — ])

  set figure(numbering: (..args) => context {
    let heading-nums = counter(heading).get()
    let fig-num = args.pos().first()
    
    if heading-nums.len() > 0 and heading.numbering == appendix-numbering {
      let letter = appendix-letters.at(heading-nums.first() - 1)
      [#letter.#fig-num]
    } else {
      str(fig-num) 
    }
  })

  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.caption.where(kind: image): set align(center)

  // 3. АДАПТИРОВАННАЯ НАСТРОЙКА ПОДПИСЕЙ И ПЕРЕНОСОВ ДЛЯ ТАБЛИЦ
  show figure: it => {
    if is-gost-table(it) or it.kind == table {
      set figure(supplement: [Таблица])
      set figure.caption(position: top)
      set block(breakable: true, sticky: true)
      
      show figure.caption: set align(left)
      show figure.caption: set par(first-line-indent: (amount: 0cm, all: false))
      
      it
    } else {
      it
    }
  }

  // 4. НАШЕ ОФИЦИАЛЬНОЕ ШОУ-ПРАВИЛО ДЛЯ ТАБЛИЦ-GRID
  show table: it => {
    set text(size: 12pt)
    
    // ВАШ НАДЕЖНЫЙ И ПРОВЕРЕННЫЙ МЕТОД ПОЛНОГО УНИЧТОЖЕНИЯ ОТСТУПОВ
    // Мы перехватываем списки прямо перед сборкой сетки
    show list.item: item-it => block(width: 100%)[
      #set par(first-line-indent: (amount: 0cm, all: true))
      -#h(0.5em, weak: true)#item-it.body
    ]

    // Безопасный перехват нумерованных списков без привязки к внешним переменным counter
    show enum: enum-it => {
      enum-it.children.enumerate().map(((index, item)) => {
        let current-num = index + 1 // Номер всегда начинается с 1 для конкретной ячейки
        block(width: 100%)[
          #str(current-num))#h(0.5em, weak: true)#item.body
        ]
      }).join()
    }
    
    let pos-args = it.children
    let named-args = it.fields()
    let _ = named-args.remove("children") 
    
    let columns = named-args.at("columns", default: auto)
    let header-align = center + horizon
    
    let found-header = pos-args.find(item => type(item) == content and item.func() == table.header)
    
    let cols-count = if type(columns) == int { 
      columns 
    } else if type(columns) == array { 
      columns.len() 
    } else if found-header != none {
      found-header.fields().at("children", default: ()).len()
    } else { 
      1 
    }
    
    let new-pos-args = ()
    
    for item in pos-args {
      if type(item) == content and item.func() == table.header {
        let header-fields = item.fields()
        let children = header-fields.remove("children", default: ())
        
        let new-children = children.map(cell => {
          if type(cell) == content and cell.func() == table.cell {
            let fields = cell.fields()
            let body = fields.remove("body") 
            if not "align" in fields or fields.align == none { fields.align = header-align }
            grid.cell(body, ..fields)
          } else {
            grid.cell(align: header-align, cell)
          }
        })
        
        let separator-line = range(cols-count).map(_ => grid.cell(
          inset: (top: 1.25pt, bottom: 1.25pt),
          stroke: (top: 0.5pt, bottom: 0.5pt, left: none, right: none),
          []
        ))
        
        new-pos-args.push(grid.header(..new-children, ..separator-line, ..header-fields))
      } else {
        if type(item) == content and item.func() == table.cell {
          let fields = item.fields()
          let body = fields.remove("body")
          new-pos-args.push(grid.cell(body, ..fields))
        } else {
          new-pos-args.push(item)
        }
      }
    }

    let final-columns = if columns == auto and cols-count > 1 { 
      (auto,) * cols-count 
    } else { 
      columns 
    }

    named-args.columns = final-columns
    if not "stroke" in named-args or named-args.stroke == none {
      named-args.stroke = 0.5pt
    }

    grid(
      ..new-pos-args,
      ..named-args
    )
  }




/////////////////////////////////////////////////////////////////////////////////////////

  // Настройка подписей рисунков
  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.caption.where(kind: image): set align(center)

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
