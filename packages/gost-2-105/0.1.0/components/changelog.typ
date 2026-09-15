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
