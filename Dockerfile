
FROM ghcr.io/jumpserver-dev/docker-vnc-desktop:base

RUN pip install selenium==4.4.0

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=app-apt \
    --mount=type=cache,target=/var/lib/apt,sharing=locked,id=app-apt \
    apt-get update \
    && apt install -y chromium chromium-driver \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY app /opt/app