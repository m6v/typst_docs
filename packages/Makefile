PACKAGE_NAME =vector
VERSION = 0.1.0

TARGET_DIR = $(HOME)/.local/share/typst/packages/local

.PHONY: all install clean

all: install

# Установка или обновление шаблона
install:
	@echo "Создание директории: $(TARGET_DIR)"
	@mkdir -p "$(TARGET_DIR)"
	@echo "Копирование файлов и папок..."
	@find . -maxdepth 1 -type d ! -name "." ! -name ".*" -exec cp -r {} $(TARGET_DIR)/ \;
	@echo "Готово."

# Удаление шаблона из системы
clean:
	@echo "Удаление шаблона из $(TARGET_DIR)"
	@rm -rf "$(TARGET_DIR)"
	@echo "Готово."
