#!/bin/env make -f

# Source path
SOURCE_PATH = src
INSTALL_PATH = /usr/bin
APP_NAME = ddns

MANPAGE = n
BASH_COMPLETION = n

# Phony targets
.PHONY: install clean

# Default target
all: install

# Install the bash script
install:

# Check if jq is installed
ifeq ($(shell which jq > /dev/null 2>&1; echo $$?), 1)
	@echo "jq is not installed. Please install it to continue."
	@exit 1
else
	@echo "jq is installed."
endif

	install -d /usr/share//doc/$(APP_NAME)

	install -m 755 ./VERSION /usr/share/doc/$(APP_NAME)/version
	install -m 755 ./COPYING /usr/share/doc/$(APP_NAME)/license

	install -m 755 $(SOURCE_PATH)/$(APP_NAME) $(INSTALL_PATH)

ifeq ($(BASH_COMPLETION),y)
	install -m 644 $(SOURCE_PATH)/$(APP_NAME)-completion /etc/bash_completion.d/$(APP_NAME)
endif

ifeq ($(MANPAGE),y)
# Check if pandoc is installed
	ifeq ($(shell which pandoc > /dev/null 2>&1; echo $$?), 1)
		@echo "Pandoc is not installed. Please install it to continue."
		@exit 1
	else
		@echo "Pandoc is installed."
	endif

	@pandoc -s -t man $(SOURCE_PATH)/doc/$(APP_NAME).8.md -o $(SOURCE_PATH)/$(APP_NAME).8
	@gzip -9 -c $(SOURCE_PATH)/$(APP_NAME).8 > $(SOURCE_PATH)/$(APP_NAME).8.gz
	install -m 644 $(SOURCE_PATH)/$(APP_NAME).8.gz /usr/share/man/man8/

# Update manpage database
	@mandb > /dev/null || { echo "Failed to update manpage database" ; exit 1; }

endif

# Clean up build files (if any)
uninstall:
	rm -f $(INSTALL_PATH)/$(APP_NAME)
	rm -f /etc/bash_completion.d/$(APP_NAME)
	rm -rf /usr/share/man/man8/$(APP_NAME).8.gz
	rm -rf /usr/share/$(APP_NAME)

clean:
	@rm -vf $(SOURCE_PATH)/$(APP_NAME).8.gz
	@rm -vf $(SOURCE_PATH)/$(APP_NAME).8

help:
	@echo "Usage: make [target] <variables>"
	@echo ""
	@echo "Targets:"
	@echo "  install   - Install the script"
	@echo "  uninstall - Uninstall the script"
	@echo "  clean     - Clean up build files"
	@echo "  help      - Display this help message"
	@echo ""
	@echo "Variables:"
	@echo "  MANPAGE   - Set to 'y' to install manpage (default: n)"
	@echo "  COMPLETION - Set to 'y' to install bash completion (default: n)"
