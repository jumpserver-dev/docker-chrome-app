
FROM 2970298425/build:tigervnc

RUN --mount=type=cache,target=/root/.cache \
    set -ex \
    && python3 -m venv /opt/py3 \
    && . /opt/py3/bin/activate \
    && pip install selenium==4.4.0

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=app-apt \
    --mount=type=cache,target=/var/lib/apt,sharing=locked,id=app-apt \
    apt-get update \
    && apt install -y chromium chromium-driver openssh-server \
    && mkdir -p /var/run/sshd \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*


WORKDIR /opt

ENV PATH=/opt/py3/bin:$PATH \
    GTK_IM_MODULE="ibus" \
    XMODIFIERS="@im=ibus" \
    QT_IM_MODULE="ibus"

COPY app /opt/app
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY .config/dconf /root/.config/dconf
COPY openbox /root/.config/openbox
COPY tint2 /root/.config/tint2

CMD ["bash", "/usr/local/bin/entrypoint.sh"]