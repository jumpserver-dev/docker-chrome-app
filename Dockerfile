FROM python:3.11-slim-bullseye
ARG TARGETARCH

ARG DEPENDENCIES="                \
    ca-certificates               \
    dbus-x11                      \
    fonts-wqy-microhei            \
    gnupg2                        \
    ibus                          \
    ibus-pinyin                   \
    iso-codes                     \
    libffi-dev                    \
    libgbm-dev                    \
    libnss3                       \
    libssl-dev                    \
    locales                       \
    netcat-openbsd                \
    pulseaudio                    \
    unzip                         \
    wget                          \
    autocutsel                    \
    procps                        \
    tigervnc-standalone-server    \
    openbox                       \
    obconf                        \
    tint2                         \
    menu                          \
    vim                           \
    openssh-client                \
    python-tk                     \
    python3-tk                    \
    tk-dev                        \
    xdg-user-dirs"  

ARG APT_MIRROR=http://mirrors.ustc.edu.cn

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=app-apt \
    --mount=type=cache,target=/var/lib/apt,sharing=locked,id=app-apt \
    sed -i "s@http://.*.debian.org@${APT_MIRROR}@g" /etc/apt/sources.list \
    && rm -f /etc/apt/apt.conf.d/docker-clean \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install -y --no-install-recommends ${DEPENDENCIES} \
    && echo "no" | dpkg-reconfigure dash \
    && echo "zh_CN.UTF-8" | dpkg-reconfigure locales \
    && sed -i "s@# export @export @g" ~/.bashrc \
    && sed -i "s@# alias @alias @g" ~/.bashrc \
    && chmod +x /dev/shm \
    && mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=app-apt \
    --mount=type=cache,target=/var/lib/apt,sharing=locked,id=app-apt \
    apt-get update \
    && apt install -y chromium chromium-driver \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN --mount=type=cache,target=/root/.cache \
    set -ex \
    && python3 -m venv /opt/py3 \
    && . /opt/py3/bin/activate \
    && pip install selenium==4.4.0

RUN groupadd -r jumpserver && \
    useradd -r -g jumpserver -d /home/jumpserver -s /bin/bash -m jumpserver

USER jumpserver
RUN LANG=C xdg-user-dirs-update --force

WORKDIR /opt

ENV PATH=/opt/py3/bin:$PATH \
    GTK_IM_MODULE="ibus" \
    XMODIFIERS="@im=ibus" \
    QT_IM_MODULE="ibus"

COPY  --chown=jumpserver:jumpserver app /opt/app
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY .config/dconf /home/jumpserver/.config/dconf
COPY --chown=jumpserver:jumpserver openbox /home/jumpserver/.config/openbox
COPY --chown=jumpserver:jumpserver tint2 /home/jumpserver/.config/tint2

CMD ["bash", "/usr/local/bin/entrypoint.sh"]