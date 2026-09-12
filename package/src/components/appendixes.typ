// Константы и глобальное состояние для приложений
#let appendix-letters = ("А", "Б", "В", "Г", "Д", "Е", "Ж", "И", "К", "Л", "М", "Н", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ш", "Щ", "Э", "Ю", "Я")
#let appendix-counter = counter("appendix")

// Функция вызывается генерации номеров приложений (в тексте и оглавлении)
#let appendix-numbering(..args) = {
  let nums = args.pos()
  if nums.len() == 1 {
    let letter = appendix-letters.at(nums.first() - 1)
    [Приложение #letter]
  } else {
    let letter = appendix-letters.at(nums.first() - 1)
    let sub-nums = nums.slice(1).map(str).join(".")
    [#letter.#sub-nums]
  }
}

// Шоу-правило, которое меняет схему нумерации и сбрасывает счетчики
#let appendixes(body) = {
  set heading(numbering: appendix-numbering)
  
  // Сброс системных счетчиков
  counter(heading).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  
  body
}
