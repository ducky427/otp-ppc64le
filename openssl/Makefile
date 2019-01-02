include ../common.mk

OPENSSL_SRC_TGZ_FILE := openssl-$(OPENSSL_VERSION).tar.gz
OPENSSL_TARBALL_URL := https://www.openssl.org/source/$(OPENSSL_SRC_TGZ_FILE)

SRC_DIR := $(BUILD_DIR)/openssl-$(OPENSSL_VERSION)

$(OPENSSL_SRC_TGZ_FILE):
	wget -O $(OPENSSL_SRC_TGZ_FILE) $(OPENSSL_TARBALL_URL)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(DIST_DIR):
	mkdir $(DIST_DIR)

$(SRC_DIR): $(BUILD_DIR) $(OPENSSL_SRC_TGZ_FILE)
	tar -zxf $(OPENSSL_SRC_TGZ_FILE) -C $(BUILD_DIR)
	touch $@

$(SRC_DIR)/Makefile: $(SRC_DIR) $(DIST_DIR)
	cd $(SRC_DIR) && ./Configure no-apps no-shared no-dso linux-$(TARGET_ARCH) --prefix=$(abspath $(DIST_DIR))

default: $(SRC_DIR)/Makefile
	$(MAKE) -j -C $(SRC_DIR) depend && $(MAKE) -j -C $(SRC_DIR) \
	CC=$(CC) \
	RANLIB=$(RANLIB) && $(MAKE) -C $(SRC_DIR) install

clean:
	rm -rf build dist

.PHONY: clean
.DEFAULT_GOAL := default

