.PHONY: install
install:
	bash ./installer.sh

.PHONY: uninstall
uninstall:
	bash ./uninstaller.sh

.PHONY: all
all: install
