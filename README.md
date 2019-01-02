# OTP on PPC

Cross compiles OTP on Linux x86_64 for ppc64le.

## TL;DR

The AT variant ppc64le (READ: LOWER ENDIAN) is vital, because BIG ENDIAN binaries will not run on the target machine.

## Pre-requisites

* Internet access
* Centos 3.10.0-862.14.4.el7.x86_64 build slave
* Root user access to the build slave

## Cross Compilation With AT

This recipe leverages the [IBM Advance Toolchain](https://developer.ibm.com/linuxonpower/advance-toolchain/). The AT toolkit provides a version of GCC that compiles on x86_64 and produces output suitable for ppc64le.

# Methodology

* Bootstraping the build environment will ensure the basic build tools are present:

        $ make -C at

* The bootstrap Makefile provides the mandatory build tools:

    * wget
    * autoconf
    * gcc
    * advance-toolchain-at12.0-cross-ppc64le

* If these tools are supplied by alternative means (e.g. yum install into a base image to speed up the build), you can still run `make -C at` to ensure that all of the tools are present

# Target System Requirements

(Note to RPM builder: Ideally the OTP RPM should specify a dependency on advance-toolchain-at12.0-runtime-12.0-0.ppc64le)

This recipe links the Erlang/OTP runtime against the runtime library from the IBM Advance Toolchain (AT).

There is a runtime dependency on the AT glibc version for ppc64le. This can be installed from the official RPMs from IBM.

If the target machine has internet access, you can register the AT YUM repo:

        [advance-toolchain]
        name=Advance Toolchain Unicamp FTP
        baseurl=ftp://ftp.unicamp.br/pub/linuxpatch/toolchain/at/redhat/RHEL7
        failovermethod=priority
        enabled=1
        gpgcheck=1
        gpgkey=ftp://ftp.unicamp.br/pub/linuxpatch/toolchain/at/redhat/RHEL7/gpg-pubkey-6976a827-5164221b

To trust the AT public key, you can download it and import it:

        $ wget ftp://ftp.unicamp.br/pub/linuxpatch/toolchain/at/redhat/RHEL7/gpg-pubkey-6976a827-5164221b
        $ rpm --import gpg-pubkey-6976a827-5164221b

However, if the target maachine is not connected to the internet, you will need to download/upload the RPM directly:

    ftp://ftp.unicamp.br/pub/linuxpatch/toolchain/at/redhat/RHEL7/at12.0/advance-toolchain-at12.0-runtime-12.0-0.ppc64le.rpm

Then install the RPM manually:

        $ rpm -i advance-toolchain-at12.0-runtime-12.0-0.ppc64le.rpm

NOTE: If you don't copy / paste these commands, make 100% sure you use `ppc64le`, not `ppc64`!

# Verfying the Install

This command invokes a non-interactive Erlang shell to print the supported SSL versions to stdout:

        $ erl -noshell -eval 'io:format("~p~n",[ssl:versions()])' -eval 'init:stop()'

This could be run as part of the RPM install.

# Improvements

* RPM packaging
* Enable HiPE

# RPM

Right now this recipe produces an binary OTP distribution that can be tarred and uploaded to the target machine.

So there is no RPM spec yet. A RPM spec would have: 

* Deliver the contents of $(DIST_DIR) and run the packaged script `./Install -sasl $*TARGET_DIR)`
* Reference the AT runtime library