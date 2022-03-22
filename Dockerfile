FROM debian:buster

COPY buster-backports.list /etc/apt/sources.list.d

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	gcc make git libssl-dev bison flex libelf-dev libssl-dev libc-dev libc6-dev-i386 libcap-dev bc \
	gcc-x86-64-linux-gnu binutils-x86-64-linux-gnu gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu \
	tar xz-utils curl ca-certificates python3-pip python3-setuptools dwarves/buster-backports \
	&& rm -rf /var/lib/apt/lists/*

# The LLVM repos need ca-certificates to be present.
COPY llvm-snapshot.gpg /usr/share/keyrings
COPY llvm.list /etc/apt/sources.list.d

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	clang-14 llvm-14 \
	&& rm -rf /var/lib/apt/lists/*

RUN pip3 install https://github.com/amluto/virtme/archive/refs/heads/master.zip

VOLUME /work

CMD ["/work/make.sh"]
