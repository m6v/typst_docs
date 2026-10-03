#import "@local/gost-2-105:0.1.0": *

#let text-document(doc-id: "", body) = {
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

  gost-document(doc-id: doc-id, body)
}
