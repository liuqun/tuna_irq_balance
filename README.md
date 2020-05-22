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
./print-irq-list.py
```

# 运行效果如下：
```
# ./print-irq-list.py 
 IRQ  NIC(-TxRx-N) CPU-affinity  NIC-driver
 124  eno1         0,1,2,3       igb
 125  eno1-TxRx-0  0,1,2,3       igb
 126  eno1-TxRx-1  0,1,2,3       igb
 127  eno1-TxRx-2  0,1,2,3       igb
 128  eno1-TxRx-3  0,1,2,3       igb
 131  eno2         0,1,2,3       igb
 132  eno2-TxRx-0  0,1,2,3       igb
 133  eno2-TxRx-1  0,1,2,3       igb
 134  eno2-TxRx-2  0,1,2,3       igb
 135  eno2-TxRx-3  0,1,2,3       igb
```
