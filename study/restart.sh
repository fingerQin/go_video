#!/bin/sh
# 重启main
# 2014-01-28

# 程序Path
VideoSystemMaster="/root/gowork/6/src/study/VideoSystemMaster"

# 编译Go
/usr/local/go/bin/go build VideoSystemMaster.go

# 得到进程ID再干掉。
for pid in `ps auxf | grep VideoSystemMaster | awk -F " " '{print $2}'`
do
    kill -9 $pid
done

# 启动进程
nohup $VideoSystemMaster &
