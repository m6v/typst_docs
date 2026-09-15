TARGET_DIR = $(HOME)/.local/share/typst/packages/local
GEANY_CONF := $(HOME)/.config/geany/filetype_extensions.conf

.PHONY: all install clean geany

all: install

# Установка локальных пакетов typst
install:
	@echo "Создание директории: $(TARGET_DIR)"
	@mkdir -p "$(TARGET_DIR)"
	@echo "Копирование файлов и папок..."
	@find . -maxdepth 1 -type d ! -name "." ! -name ".*" -exec cp -r {} $(TARGET_DIR)/ \;
	@echo "Готово."

# Настройка конфигурации geany
geany:
	@mkdir -p $(dir $(GEANY_CONF))
	@touch $(GEANY_CONF)
	@grep -qF 'Typst=*.typ;' $(GEANY_CONF) || \
		(grep -q '^\[Extensions\]' $(GEANY_CONF) && \
		sed -i '/^\[Extensions\]/a Typst=*.typ;' $(GEANY_CONF) || \
		printf '\n[Extensions]\nTypst=*.typ;\n' >> $(GEANY_CONF))
	@cp -u filetypes.Typst.conf $(HOME)/.config/geany/filedefs

# Удаление локальных пакетов typst
clean:
	@echo "Удаление пакетов typst из $(TARGET_DIR)"
	@rm -rf "$(TARGET_DIR)"
	@echo "Готово."

# TODO Сделать настройку geany: `typst watch "%d/main.typ" --open` или `typst watch "%d/main.typ" & WATCH_PID=$!; evince "%d/main.pdf"; kill $WATCH_PID` для открытия и автообновления документа при изменении исходных файлов. Последний вариант завершмет typst watch при закрытии просмотрщика pdf.
