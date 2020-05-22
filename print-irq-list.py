#! /usr/bin/python3
# -*- python -*-
# -*- coding: utf-8 -*-

import ethtool
import procfs
import sys


nr_cpus = None

def get_nr_cpus():
        global nr_cpus
        if nr_cpus:
                return nr_cpus
        nr_cpus = procfs.cpuinfo().nr_cpus
        return nr_cpus

nics = None

def get_nics():
        global nics
        if nics:
                return nics
        nics = ethtool.get_active_devices()
        return nics

def find_drivers_by_users(users):
        nics = get_nics()
        drivers = []
        for u in users:
                try:
                        idx = u.index('-')
                        u = u[:idx]
                except:
                        pass
                if u in nics:
                        driver = ethtool.get_module(u)
                        if driver not in drivers:
                                drivers.append(driver)

        return drivers

def format_affinity(affinity):
        if len(affinity) <= 4:
                return ",".join(str(a) for a in affinity)

        return ",".join(str(hex(a)) for a in procfs.hexbitmask(affinity, get_nr_cpus()))

def print_irqs_used_by_network_interface_cards(irq_list, cpu_list):
        irqs = procfs.interrupts()

        if sys.stdout.isatty():
                print("%4s  %-12s %-12s  %s" % ("IRQ", "NIC(-TxRx-N)", "CPU-affinity", "NIC-driver"))
        sorted_irqs = []
        for k in list(irqs.keys()):
                try:
                        irqn = int(k)
                        affinity = irqs[irqn]["affinity"]
                except:
                        continue
                if irq_list and irqn not in irq_list:
                        continue

                if cpu_list and not set(cpu_list).intersection(set(affinity)):
                        continue
                sorted_irqs.append(irqn)

        sorted_irqs.sort()
        for irq in sorted_irqs:
                affinity = format_affinity(irqs[irq]["affinity"])
                users = irqs[irq]["users"]
                is_nic = False
                for i in users:
                        # 网卡IRQ名称必定以en开头或eth开头
                        is_nic = i.startswith("en") or i.startswith("eth")
                        if is_nic:
                                break
                if not is_nic:
                        continue
                print("%4d  %-12s %-12s" % (irq, ",".join(users), affinity), end=' ')
                drivers = find_drivers_by_users(users)
                if drivers:
                        print(" %s" % ",".join(drivers))
                else:
                        print()

def main():
        cpu_list = None
        irq_list = None
        # irq_list_str = None
        print_irqs_used_by_network_interface_cards(irq_list, cpu_list)


if __name__ == '__main__':
    main()
