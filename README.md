# 使用说明

Ubuntu 需要安装的软件包如下

```
sudo apt-get install -y \
    python3 \
    python3-ethtool \
    python3-linux-procfs \
    python3-schedutils
```

安装上述开发工具后，克隆（或下载）本项目，并在本机运行 IRQ Toolbox 工具箱内的脚本工具：

```
git clone http://xinfanshi.trapbox.cn:13080/liuqun/irq-toolbox.git

cd irq-toolbox

python3 ./print-irq-list.py
```

# 运行效果如下：

```
# python3 ./print-irq-list.py 
 IRQ CPU-lcore NIC-TxRx-Queue   NIC-driver
 126        2  eno1             igb
 127  0,1,2,3  eno1-TxRx-0      igb
 128  0,1,2,3  eno1-TxRx-1      igb
 129  0,1,2,3  eno1-TxRx-2      igb
 130  0,1,2,3  eno1-TxRx-3      igb
 131        3  eno2             igb
 132        0  eno2-TxRx-0      igb
 133        1  eno2-TxRx-1      igb
 134        2  eno2-TxRx-2      igb
 135        3  eno2-TxRx-3      igb  

# 联想千兆网卡服务器
# CPU型号：酷睿i3-7100(开启HT超线程后CPU=4逻辑核)
# 网卡型号
eno1  I210 Gigabit Network Connection
eno2  I210 Gigabit Network Connection
```
