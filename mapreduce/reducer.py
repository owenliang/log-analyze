# coding=utf-8

import json
import sys

last_event = None
counter = 0

# reducer输出
def emit():
    output = [last_event['ec'], last_event['ea'], last_event['el'], str(counter)]
    output = '\t'.join(output)
    print(output)

# 判断事件是否相同
def event_changed(event):
    return event['ec'] != last_event['ec'] or event['ea'] != last_event['ea'] or event['el'] != last_event['el']

# 读mapper输出
for line in sys.stdin:
    # 读map输出的一行
    line = line.strip()

    try:
        # 分割
        fields = line.split('\t')

        # map输出的key
        key = fields[0]
        # 解析key为事件标识
        event = json.loads(key)

        if last_event is None:
            last_event = event

        # 输出前一个key的累加信息
        if event_changed(event):
            emit()
            last_event = event
            counter = 1
        else: # 统计次数+1
            counter += 1
    except Exception as e:
        sys.stderr.write(str(e) + '\n')

if last_event is not None:
    emit()