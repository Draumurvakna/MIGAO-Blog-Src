---
categories:
- Note
cover: /gallery/Unity.png
date:
- 2024-08-01 15:21:10
tags:
- Unity
- linux
- python
- Capstone
thumbnail: /thumb/Unity.png
title: "\u5939\u722A\u63A7\u5236\u65B9\u5F0F"
toc: true

---
# 夹爪控制方式

使用 pyRobotiqGripper

但是只兼容 linux 电脑的串口，所以部署在笔记本上并且创建一个局域网服务器供台式机调用。

```python
import pyRobotiqGripper
import time
from flask import Flask, request

app = Flask(__name__)
gripper = pyRobotiqGripper.RobotiqGripper()
gripper.activate()

@app.route('/open_gripper', methods=['POST'])
def open_gripper():
    # 执行脚本
    # import subprocess
    # subprocess.call(['/path/to/your/script.sh'])
    gripper.open()
    return 'gripper open'
@app.route('/close_gripper', methods=['POST'])
def close_gripper():
    # 执行脚本
    # import subprocess
    # subprocess.call(['/path/to/your/script.sh'])
    gripper.close()
    return 'gripper closed'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

# gripper = pyRobotiqGripper.RobotiqGripper()
# gripper.activate()
# gripper.close()
# gripper.open()
# time.sleep(3)
# gripper.close()
```

```sql
(base) cyl@arch ~/450> python gripper_test.py
Activation completed. Activation time :  1.9049019813537598
 * Serving Flask app 'gripper_test'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production 
WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://192.168.2.111:5000
Press CTRL+C to quit
192.168.2.103 - - [20/Jul/2024 16:26:01] "POST /open_gripper HTTP/1.1" 200 -
192.168.2.103 - - [20/Jul/2024 16:26:05] "POST /close_gripper HTTP/1.1" 200 -
192.168.2.103 - - [20/Jul/2024 16:26:07] "POST /close_gripper HTTP/1.1" 200 -
192.168.2.103 - - [20/Jul/2024 16:26:10] "POST /close_gripper HTTP/1.1" 200 -
192.168.2.103 - - [20/Jul/2024 16:26:13] "POST /close_gripper HTTP/1.1" 200 -
192.168.2.103 - - [20/Jul/2024 16:26:16] "POST /close_gripper HTTP/1.1" 200 -
192.168.2.103 - - [20/Jul/2024 16:26:18] "POST /close_gripper HTTP/1.1" 200 -
192.168.2.103 - - [20/Jul/2024 16:26:21] "POST /close_gripper HTTP/1.1" 200 -
192.168.2.103 - - [20/Jul/2024 16:26:24] "POST /close_gripper HTTP/1.1" 200 -
```

台式机通过

```python
# 定义要发送的命令和URL
laptop_ip = "192.168.2.111"
close_url = "http://"+laptop_ip+":5000/close_gripper"
open_url = "http://"+laptop_ip+":5000/open_gripper"

# 使用curl命令通过POST请求发送命令
curl_close_command = [
    'curl', 
    '-X', 'POST', 
    close_url, 
]

curl_open_command = [
    'curl', 
    '-X', 'POST', 
    open_url, 
]

print(subprocess.run(curl_open_command, capture_output=True, text=True))
```

来控制
