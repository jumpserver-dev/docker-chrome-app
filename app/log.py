def write_log(message, logfile='/tmp/chrome-app.log'):
    """
    写日志方法，可以被其他脚本调用

    :param message: 要写入的日志内容
    :param logfile: 日志文件路径，默认为 /tmp/chrome-app.log
    """
    try:
        with open(logfile, 'a', encoding='utf-8') as f:
            f.write(str(message) + '\n')
    except Exception as e:
        # 可根据需要决定是否抛出异常或将异常信息打印出来
        pass
