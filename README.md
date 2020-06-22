# 使用说明

# 在Ubuntu下安装网卡管理/CPU中断管理相关的底层开发工具
Ubuntu 需要安装的软件包如下

```
sudo apt-get install -y \
    python3 \
    python3-ethtool \
    python3-linux-procfs \
    python3-schedutils
```

可选安装下列工具（推荐）:
```
sudo apt-get install -y ethtool tuna
```

# 修改默认IRQ配置或强制关闭Ubuntu的irqbalance后台服务进程

## 1. 修改IRQ配置并重启更新irqbalance后台服务进程
编辑etc目录中的文本配置文件`/etc/default/irqbalance`。

添加如下CPU掩码（排除CPU4～CPU15，只保留CPU0～CPU3）：
```
IRQBALANCE_BANNED_CPUS=00000000,0000fff0
```

然后执行：

    sudo systemctl restart irqbalance

重启irqbalance服务即可以使上述配置生效。

## 2. 迁移本机全部进程（以及中断服务程序）的CPU亲和性
下列命令可强制修改本机所有进程以及中断服务程序的CPU亲和性，
将所有进程迁移至前4块CPU0～CPU3上执行：
```
sudo tuna --irqs "*" --cpus 0-3 --move --spread
sudo tuna --threads "*" --cpus 0-3 --move --spread
```


# 使用本工具箱
安装上述开发工具后，克隆（或下载）本项目，并在本机运行 IRQ Toolbox 工具箱内的脚本工具：

```
git clone https://github.com/liuqun/tuna_irq_balance.git

cd tuna_irq_balance

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

# 其他关于irqbalance的问题

## 如何临时关闭irqbalance服务
下列命令可临时关闭irqbalance服务（直到下一次重启之前有效）
```
sudo systemctl stop irqbalance
```

## 如何永久禁用irqbalance服务
该方案可永久关闭irqbalance服务（重启后仍保持禁用状态）。
缺点：可能影响其他硬件设备或系统服务进程的IRQ负载均衡，故不推荐生产环境使用。
```
sudo systemctl stop irqbalance
sudo systemctl disable irqbalance
```
