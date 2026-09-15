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
