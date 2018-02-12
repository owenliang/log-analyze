#!/usr/bin/env python3
# coding=utf-8

import json
import sys

for line in sys.stdin:
    # 原始文件输入的一行
    line = line.strip()
    try:
        # 解析json
        log_item = json.loads(line)

        # shuffle的key
        map_key = json.dumps({"ec": log_item["ec"], "ea": log_item["ea"], "el": log_item["el"]})

        # 输出map阶段结果
        output = "{}\t{}".format(map_key, line)
        print(output)

    except Exception as e:
        sys.stderr.write(str(e) + '\n')