include ../common.mk

define ensure_installed
	rpm -qa | grep '^$(notdir $(1))' || yum install -y $(notdir $(1))-$2
endef

define ensure_gpg_key
	rpm -qa gpg-pubkey | grep $(1) > $(2) || rpm --import $(AT_REPO_URL)/$(1) > $(2) 
endef

YUM_REPO_BASE := /etc/yum.repos.d
GPG_MARKER_FILE := at_gpg_key.txt
AT_PUB_KEY := gpg-pubkey-6976a827-5164221b
AT_REPO_URL := ftp://ftp.unicamp.br/pub/linuxpatch/toolchain/at/redhat/RHEL7
AT_REPO_FILE := at.repo
AT_REPO_ENTRY := $(YUM_REPO_BASE)/$(AT_REPO_FILE)

$(WGET):
	$(call ensure_installed,$@,$(WGET_RPM_VERSION))

$(AUTOCONF):
	$(call ensure_installed,$@,$(AUTOCONF_RPM_VERSION))

$(BUILD_CC):
	$(call ensure_installed,$@,$(GCC_RPM_VERSION))

$(GPG_MARKER_FILE):
	$(call ensure_gpg_key,$(AT_PUB_KEY),$@)

.ONESHELL:
$(AT_REPO_FILE):
	cat <<- EOF > $@
		[advance-toolchain]
		name=Advance Toolchain Unicamp FTP
		baseurl=$(AT_REPO_URL)
		failovermethod=priority
		enabled=1
		gpgcheck=1
		gpgkey=ftp://ftp.unicamp.br/pub/linuxpatch/toolchain/at/redhat/RHEL7/$(AT_PUB_KEY)
	EOF

$(AT_REPO_ENTRY): $(AT_REPO_FILE) | $(GPG_MARKER_FILE)
	cp $(AT_REPO_FILE) $(YUM_REPO_BASE)

$(CC): | $(AT_REPO_ENTRY)
	$(call ensure_installed,$(AT_PACKAGE_NAME))

default: $(CC) $(AUTOCONF) $(BUILD_CC) $(WGET)

clean:
	rm -f $(GPG_MARKER_FILE) $(AT_REPO_FILE)
	rm -f *.html 

.PHONY: clean
.DEFAULT_GOAL := default
