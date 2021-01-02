SHELL:=/bin/sh
DOCKER_TAG_FILE:=docker_tag
XKBLAYOUT_STATE_URL:=https://github.com/nonpop/xkblayout-state
XKB_SWITCH_URL:=https://github.com/grwlf/xkb-switch


UID:=$(shell id -u)
GID:=$(shell id -g)

define DOCKER_FILE
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y build-essential cmake libx11-dev libxkbfile-dev
endef

check-presence = type $(1) >/dev/null 2>&1

define install-dependency-target
.PHONY: install-$(1)
install-$(1): activate-sudo
	$(call check-presence,$(1)) || sudo apt install $(1)
endef

.PHONY: all
all:

DEPENDENCIES = cmake xdotool
$(foreach element,$(DEPENDENCIES),$(eval $(call install-dependency-target,$(element))))


.INTERMEDIATE: $(DOCKER_TAG_FILE)
export DOCKER_FILE
$(DOCKER_TAG_FILE):
	echo "$$DOCKER_FILE" | docker build -q - > "$@"


all: xkblayout-state/xkblayout-state
xkblayout-state/xkblayout-state: $(DOCKER_TAG_FILE)
	git clone $(XKBLAYOUT_STATE_URL)
	docker run -v "$$PWD":/out -i -u $(UID):$(GID) --rm $$(cat $(DOCKER_TAG_FILE)) \
		make -C /out/xkblayout-state


.PHONY: install-xkblayout-state
install-xkblayout-state: activate-sudo xkblayout-state/xkblayout-state
	@$(call check-presence,xkblayout-state) || { \
		echo Installing xkblayout-state...; \
		sudo $(MAKE) -C xkblayout-state install; \
	}


all: xkb-switch/build/xkb-switch
xkb-switch/build/xkb-switch: $(DOCKER_TAG_FILE)
	git clone $(XKB_SWITCH_URL)
	mkdir -p xkb-switch/build
	docker run -v "$$PWD":"$$PWD" -i -u $(UID):$(GID) --rm $$(cat $(DOCKER_TAG_FILE)) \
		/bin/sh -c 'cmake -B "'"$$PWD"'"/xkb-switch/build -S "'"$$PWD"'"/xkb-switch; make -C "'"$$PWD"'"/xkb-switch/build'


.PHONY: install-xkb-switch
install-xkb-switch: xkb-switch/build/xkb-switch install-cmake activate-sudo
	@$(call check-presence,xkb-switch) || { \
		echo Installing xkb-switch...; \
		sudo $(MAKE) -C xkb-switch/build install; \
		sudo ldconfig; \
	}


.PHONY: install-xkblayout-convert
install-xkblayout-convert: install-xdotool install-xkblayout-state install-xkb-switch
	install -D -T xkblayout-convert.sh ~/.local/bin/xkblayout-convert


.PHONY: activate-sudo
activate-sudo:
	@echo The following operations require superuser rights.
	@sudo true


.PHONY: install-shortcuts
install-shortcuts:
	@if [ "$$XDG_CURRENT_DESKTOP" = "XFCE" ]; then \
		xfconf-query --create --channel xfce4-keyboard-shortcuts \
			--property '/commands/custom/<Shift>Pause' --type string \
			--set 'xkblayout-convert'; \
	else \
		echo 'Keyboard shortcut install is only supported in XFCE desktop.'; \
	fi


.PHONY: install
install: install-xkblayout-convert install-shortcuts clean


.PHONY: clean
clean:
	rm -rf xkblayout-state
	rm -rf xkb-switch
