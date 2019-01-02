OTP_RELEASE := 17.5.6.10
OPENSSL_VERSION := 1.0.2q
NCURSES_VERSION := 6.1

BUILD_ARCH := x86_64

TARGET_ARCH := ppc64le
TARGET_CPU := power8

AT_ARCH := powerpc64le
AT_VERSION := 12.0

WGET_RPM_VERSION := 1.14-15.el7_4.1.x86_64
AUTOCONF_RPM_VERSION := 2.69-11.el7.noarch
GCC_RPM_VERSION := 4.8.5-28.el7_5.1.x86_64

AT_BASE_PATH := /opt/at$(AT_VERSION)
AT_PACKAGE_NAME := advance-toolchain-at$(AT_VERSION)-cross-$(TARGET_ARCH)

CC := $(AT_BASE_PATH)/bin/$(AT_ARCH)-linux-gnu-gcc
CXX := $(AT_BASE_PATH)/bin/$(AT_ARCH)-linux-gnu-g++
LD := $(AT_BASE_PATH)/bin/$(AT_ARCH)-linux-gnu-ld
AR := $(AT_BASE_PATH)/bin/$(AT_ARCH)-linux-gnu-ar
RANLIB := $(AT_BASE_PATH)/bin/$(AT_ARCH)-linux-gnu-ranlib

WGET := /usr/bin/wget
AUTOCONF := /usr/bin/autoconf
BUILD_CC := /usr/bin/gcc

BUILD_DIR := build
DIST_DIR := dist

OTP_INSTALL_DIR := /opt/erlang-otp/current
