#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import subprocess
from common import convert_base64_to_dict
from app import AppletApplication


def main():
    token = os.environ.get('JMS_TOKEN')
    if not token:
        subprocess.call(
            ['bash','-c','GTK_IM_MODULE=xim /usr/bin/chromium --gtk-version=4 --start-maximized --disable-gpu --ignore-certificate-errors --no-sandbox --disable-dev-shm-usage']
        )
        return
    data = convert_base64_to_dict(token)
    applet_app = AppletApplication(**data)
    applet_app.run()
    applet_app.wait()


if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print(e)
