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
