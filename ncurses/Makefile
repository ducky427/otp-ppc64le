include ../common.mk

TARGET_ARCH := powerpc64le

CFLAGS := "-mcpu=powerpc64le -Wl,-EL"

CONFIGURE_ARGS := --without-ada --without-cxx --without-cxx-binding --without-manpages --without-progs --without-tests

NCURSES_SRC_TGZ_FILE := ncurses-$(NCURSES_VERSION).tar.gz
NCURSES_TARBALL_URL := http://ftp.gnu.org/pub/gnu/ncurses/$(NCURSES_SRC_TGZ_FILE)

SRC_DIR := $(BUILD_DIR)/ncurses-$(NCURSES_VERSION)

$(NCURSES_SRC_TGZ_FILE):
	wget -O $(NCURSES_SRC_TGZ_FILE) $(NCURSES_TARBALL_URL)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(DIST_DIR):
	mkdir $(DIST_DIR)

$(SRC_DIR): $(BUILD_DIR) $(NCURSES_SRC_TGZ_FILE)
	tar -zxf $(NCURSES_SRC_TGZ_FILE) -C $(BUILD_DIR)
	touch $@

$(SRC_DIR)/Makefile: $(SRC_DIR) $(DIST_DIR)
	cd $(SRC_DIR) && CC=$(CC) \
	./configure \
	--build=$(BUILD_ARCH) \
	--host=$(TARGET_ARCH) \
	--prefix=$(abspath $(DIST_DIR)) \
	$(CONFIGURE_ARGS)

default: $(SRC_DIR)/Makefile
	$(MAKE) -C $(SRC_DIR) \
	AR=$(AR) \
	CC=$(CC) \
	-j && $(MAKE) -C $(SRC_DIR) install

.DEFAULT_GOAL := default
