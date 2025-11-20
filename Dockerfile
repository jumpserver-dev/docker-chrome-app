
FROM ghcr.io/jumpserver-dev/docker-vnc-desktop:base

ARG TK_DEPS="tk\
    tcl \
    libtk8.6 \
    libtcl8.6 \
    python3-tk"


# 安装 Tcl/Tk 运行库
RUN apt-get update && \
    apt-get install -y --no-install-recommends ${TK_DEPS} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install selenium==4.4.0

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=app-apt \
    --mount=type=cache,target=/var/lib/apt,sharing=locked,id=app-apt \
    apt-get update \
    && apt install -y chromium chromium-driver \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY app /opt/app