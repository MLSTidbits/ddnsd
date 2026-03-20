.PHONY: all clean install _pandoc _out

APPLICATION = $(shell pwd | xargs basename)
VERSION = $(shell cat doc/version)

BUILD_DIR = _build
SOURCE_DIR = src
DOC_DIR = doc
MAN_DIR = man

all: _pandoc _out

_pandoc:
	@echo "Building manual page..."
	@mkdir -p $(BUILD_DIR)/$(MAN_DIR)
	@if ! command -v pandoc ; then \
		echo 'pandoc could not be found. Please install pandoc to build the manual page.'; \
		exit 1; \
	fi

	@for manpage in $(MAN_DIR)/*.md; do \
		output=$(BUILD_DIR)/$(MAN_DIR)/$$(basename "$${manpage%.md}"); \
		echo "Converting $$manpage to $$output..."; \
		pandoc -s -t man -o "$$output" "$$manpage"; \
	done

#	pandoc -s -t man -o $(BUILD_DIR)/$(MAN_DIR)/$(APPLICATION).1 $(MAN_DIR)/$(APPLICATION).1.md


_out:
	@mkdir -p $(BUILD_DIR)/doc

	@for file in $(SOURCE_DIR)/*; do \
		if [ -f "$$file" ]; then \
			cp -rf "$$file" "$(BUILD_DIR)/"; \
		fi; \
	done

	@cp -r $(SOURCE_DIR)/completion $(BUILD_DIR)/

	@cp -f $(DOC_DIR)/version $(DOC_DIR)/copyright README.md CONTRIBUTING.md CODE_OF_CONDUCT.md \
		$(BUILD_DIR)/$(DOC_DIR)/
clean:
	@echo "cleaning: removing $(BUILD_DIR) directory..."
	@rm -rf $(BUILD_DIR)

install:
	@install -Dm755 $(BUILD_DIR)/$(APPLICATION) /usr/bin/

# Install the /etc configuration file if it doesn't exist
	@if [ ! -f /etc/default/grub_btrfsd ] && [ ! -f /etc/grub.d/41_grub_btrfsd ]; then \
		echo "Installing default configuration file"; \
		install -Dm644 $(BUILD_DIR)/config /etc/ddnsd/; \
	fi

	@for manpage in $(BUILD_DIR)/$(MAN_DIR)/*; do \
		section=$$(echo "$$manpage" | sed 's/.*\.\([0-9]\+\)$$/\1/'); \
		dest=/usr/share/man/man$$section/$$(basename $$manpage); \
		install -Dm644 "$$manpage" "$$dest"; \
		gzip -9 -f "$$dest"; \
	done

	@for docs in $(BUILD_DIR)/$(DOC_DIR)/*; do \
		dest=/usr/share/doc/$(APPLICATION)/$$(basename $$docs); \
		install -Dm644 "$$docs" "$$dest"; \
	done
