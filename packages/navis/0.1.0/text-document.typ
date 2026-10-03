#import "@local/gost-2-105:0.1.0": *

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

  gost-document(doc-id: doc-id, body)
}
