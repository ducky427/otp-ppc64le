include ../common.mk

BOOTSTRAP_BEAM := bin/$(BUILD_ARCH)-unknown-linux-gnu/beam.smp

OPENSSL_PATH := ../openssl
NCURSES_PATH := ../ncurses

OPENSSL_DIST_PATH=$(abspath $(OPENSSL_PATH)/dist)
NCURSES_DIST_PATH=$(abspath $(NCURSES_PATH)/dist)

OPENSSL_STATIC_LIB := $(OPENSSL_DIST_PATH)/lib/libcrypto.a
NCURSES_STATIC_LIB := $(NCURSES_DIST_PATH)/lib/libncurses.a

CONFIGURE_ARGS := --host=$(TARGET_ARCH) \
--disable-hipe \
--enable-smp-support \
--enable-threads \
--enable-kernel-poll \
--with-termcap \
--with-ssl=$(OPENSSL_DIST_PATH) \
--disable-dynamic-ssl-lib \
--build=$(BUILD_ARCH) \
--enable-native-libs \
--enable-static-nifs

LDFLAGS := "-L$(NCURSES_DIST_PATH)/lib -L$(OPENSSL_DIST_PATH)/lib -L/opt/at12.0/$(TARGET_ARCH)/lib64"
LIBS := $(OPENSSL_STATIC_LIB)
CFLAGS := "-D_GNU_SOURCE -I$(NCURSES_DIST_PATH)/include -I$(OPENSSL_DIST_PATH)/include -mcpu=$(TARGET_CPU) -mtune=$(TARGET_CPU) -O3 -pthread"

OTP_SRC_TGZ_FILE := OTP-$(OTP_RELEASE).tar.gz
OTP_TARBALL_URL := https://github.com/erlang/otp/archive/$(OTP_SRC_TGZ_FILE)

OTP_SRC_DIR := $(BUILD_DIR)/otp-OTP-$(OTP_RELEASE)
export ERL_TOP := $(abspath $(OTP_SRC_DIR))

DO_NOT_NEED := ftp ssh eunit wx jinterface common_test debugger dialyzer diameter edoc et erl_docgen tftp megaco odbc observer 
SKIP_LIBS := $(foreach lib,$(DO_NOT_NEED),$(OTP_SRC_DIR)/lib/$(lib)/SKIP)

# The intermediate tarball is a half way house
# Ultimately we need to put the output of $(DIST_DIR) into an RPM
# And specify that the RPM needs to run the Install command (as well as specifying the the AT runtime dependency)
INTERMEDIATE_TARBALL := otp-ppc64le-v.tar.gz

$(NCURSES_STATIC_LIB):
	$(MAKE) -C $(NCURSES_PATH)

$(OPENSSL_STATIC_LIB):
	$(MAKE) -C $(OPENSSL_PATH)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(DIST_DIR):
	mkdir $(DIST_DIR)

$(OTP_SRC_TGZ_FILE):
	wget -O $(OTP_SRC_TGZ_FILE) $(OTP_TARBALL_URL)

$(OTP_SRC_DIR): $(BUILD_DIR) $(OTP_SRC_TGZ_FILE)
	tar -zxf $(OTP_SRC_TGZ_FILE) -C $(BUILD_DIR)
	touch $@

$(OTP_SRC_DIR)/configure: $(OTP_SRC_DIR)
	$(OTP_SRC_DIR)/otp_build autoconf

$(SKIP_LIBS): $(OTP_SRC_DIR)
	touch $@ || true 			# The list of libs does appear to be consistent across all versions of OTP,
								# so silently ignore something that doesn't exist

$(OTP_SRC_DIR)/$(BOOTSTRAP_BEAM): $(OTP_SRC_DIR)/configure $(SKIP_LIBS)
	cd $(OTP_SRC_DIR) && ./configure --enable-bootstrap-only
	$(MAKE) -C $(OTP_SRC_DIR) -j

$(OTP_SRC_DIR)/make/output.mk: $(SKIP_LIBS) $(NCURSES_STATIC_LIB) $(OPENSSL_STATIC_LIB) $(OTP_SRC_DIR)/$(BOOTSTRAP_BEAM)
	cd $(OTP_SRC_DIR) && erl_xcomp_sysroot=$(ERL_TOP) \
		CC=$(CC) \
		CXX=$(CXX) \
		LD=$(LD) \
		LDFLAGS=$(LDFLAGS) \
		CFLAGS=$(CFLAGS) \
		LIBS=$(LIBS) \
	 	./configure $(CONFIGURE_ARGS) --prefix=$(OTP_INSTALL_DIR)

$(DIST_DIR)/Install: $(DIST_DIR) $(OTP_SRC_DIR)/make/output.mk
	$(MAKE) -C $(OTP_SRC_DIR) -j
	$(MAKE) -C $(OTP_SRC_DIR) install DESTDIR=$(abspath $(DIST_DIR))

$(INTERMEDIATE_TARBALL): $(DIST_DIR)/Install
	tar cfzv $@ -C $(DIST_DIR) .

default: $(INTERMEDIATE_TARBALL)

clean:
	$(MAKE) -C $(OTP_SRC_DIR) clean

mrproper:
	rm -rf build dist

.PHONY: clean mrproper
.DEFAULT_GOAL := default