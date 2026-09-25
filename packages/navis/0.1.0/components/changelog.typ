// Лист регистрации изменений по ГОСТ 2.503-2013 Приложение В
#let changelog() = {
      set par(leading: 0.35em, first-line-indent: (amount: 0cm, all: false))
      show table.cell: set par(first-line-indent: (amount: 0cm, all: false))
      set table(inset: (x: 2pt, y: 3pt))

      pagebreak()
      align(center)[
        Лист регистрации изменений
        
        НЕ ПОСТАВЛЯТЬ
      ]
      set text(
        font: "Liberation Serif", 
        size: 7.5pt,              
        tracking: -0.03em         
      )
      block(
        width: 100%,
        height: 90%,
        table(
          columns: (12mm, 12mm, 12mm, 12mm, 12mm, 20mm, 35mm, 25mm, 17mm, 15mm),
          rows: (auto, auto, ..(1fr,) * 20),
          align: center + horizon,
          stroke: 0.5pt + black,

          table.header(
            table.cell(rowspan: 2)[Изм.], table.cell(colspan: 4)[Номера листов (страниц)], table.cell(rowspan: 2)[Всего листов\ (страниц)\ в документе], table.cell(rowspan: 2)[Номер\ доку-\ мента], table.cell(rowspan: 2)[Входящий номер\ сопроводи-\тельного\ документа и дата], table.cell(rowspan: 2)[Под-\ пись], table.cell(rowspan: 2)[Дата],
            [изме-\нен-\ ных], [заме-\нен-\ных], [новых], [анну-\лиро-\ ван-\ных],
            table.hline(y: 2, stroke: 1.2pt + black)
          ),
        )
      )
}
