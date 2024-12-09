#!/bin/env make -f

# Source path
SOURCE_PATH = src
INSTALL_PATH = /usr/bin
APP_NAME = ddns

# Phony targets
.PHONY: install clean

# Default target
all: install

# Install the bash script
install:
	install -m 755 $(SOURCE_PATH)/$(APP_NAME) $(INSTALL_PATH)
	install -m 644 $(SOURCE_PATH)/$(APP_NAME)-completion /etc/bash_completion.d/$(APP_NAME)

# Clean up build files (if any)
clean:
	rm -fv $(INSTALL_PATH)/$(APP_NAME)
