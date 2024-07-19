FROM arm64v8/ubuntu:22.04 AS fex-builder

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

FROM arm64v8/ubuntu:22.04 AS rootfs-fetcher

COPY --from=fex-builder /usr/bin/FEX* /usr/bin/

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
 && apt install -y \
    expect-dev \
    curl \
    squashfs-tools

RUN unbuffer FEXRootFSFetcher -x -y \
 && rm /root/.fex-emu/RootFS/Ubuntu_22_04.sqsh

FROM arm64v8/ubuntu:22.04

RUN apt update \
 && apt install -y \
    bash \
    curl \
    sudo

RUN useradd -m -s /bin/bash steam \
 && usermod -aG sudo steam \
 && echo "steam ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/steam

USER steam

WORKDIR /home/steam/Steam

RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

COPY --from=fex-builder /usr/bin/FEX* /usr/bin/
COPY --from=rootfs-fetcher --chown=steam:steam /root/.fex-emu /home/steam/.fex-emu
COPY --chmod=0755 scripts/entrypoint.sh /usr/local/bin/

ENTRYPOINT FEXBash ./steamcmd.sh

ENTRYPOINT entrypoint.sh
