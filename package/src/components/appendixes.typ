// Константы и глобальное состояние для приложений
#let appendix-letters = ("А", "Б", "В", "Г", "Д", "Е", "Ж", "И", "К", "Л", "М", "Н", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ш", "Щ", "Э", "Ю", "Я")
#let appendix-counter = counter("appendix")

// Глобальное состояние для хранения текущего статуса приложения
#let current-app-status = state("app-status", none)

// Обертка для подключения приложений
#let appendix(status: "обязательное", body) = {
  current-app-status.update(status)
  body
   // Сброс статуса после рендеринга
  current-app-status.update(none)
}

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
  
  // По умолчанию устанавливаем статус "обязательное" для всех приложений
  current-app-status.update("обязательное")
  
  // Сброс системных счетчиков
  counter(heading).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  
  body
}
