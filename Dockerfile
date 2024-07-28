FROM --platform=linux/arm64 ubuntu:22.04 AS fex-builder_arm64

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
 && apt install -y \
    git \
    cmake \
    ninja-build \
    pkgconf \
    ccache \
    clang \
    llvm \
    lld \
    binfmt-support \
    libsdl2-dev \
    libepoxy-dev \
    libssl-dev \
    python3-setuptools \
    g++-x86-64-linux-gnu \
    libgcc-10-dev-i386-cross \
    libgcc-10-dev-amd64-cross \
    nasm \
    python3-clang \
    libstdc++-10-dev-i386-cross \
    libstdc++-10-dev-amd64-cross \
    libstdc++-10-dev-arm64-cross \
    libc-bin \
    libc6-dev-i386-amd64-cross \
    lib32stdc++-10-dev-amd64-cross

RUN git clone --recurse-submodules https://github.com/FEX-Emu/FEX.git \
 && mkdir FEX/build \
 && cd FEX/build \
 && CC=clang CXX=clang++ cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DUSE_LINKER=lld -DENABLE_LTO=True -DBUILD_TESTS=False -DENABLE_ASSERTIONS=False -G Ninja .. \
 && ninja \
 && ninja install

RUN apt install -y \
    expect-dev \
    curl \
    squashfs-tools

RUN unbuffer FEXRootFSFetcher -x -y \
 && rm /root/.fex-emu/RootFS/Ubuntu_22_04.sqsh

############################################################
FROM ubuntu:22.04 AS base

RUN apt update \
 && apt install -y \
    bash \
    curl \
    sudo \
 && useradd -m -s /bin/bash steam \
 && usermod -aG sudo steam \
 && echo "steam ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/steam

############################################################
FROM --platform=linux/arm64 base AS base_arm64

COPY --from=fex-builder_arm64 /usr/bin/FEX* /usr/bin/
COPY --from=fex-builder_arm64 --chown=steam:steam /root/.fex-emu /home/steam/.fex-emu

############################################################
FROM --platform=linux/amd64 base AS base_amd64

RUN apt update \
 && apt install -y lib32gcc-s1

############################################################
FROM golang:1.22 AS tools-builder

WORKDIR /opt/app

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -v -o /usr/local/bin ./tools/...

############################################################
FROM base_${TARGETARCH}

USER steam

WORKDIR /home/steam/Steam

RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

USER root

COPY --from=tools-builder /usr/local/bin/* /usr/local/bin/
COPY --chmod=0755 scripts/entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]
