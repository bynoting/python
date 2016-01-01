# -*- coding: cp936 -*-

# FileName: modify_ip.py
# Author  : qujinlong
# Email   : qujinlong123@gmail.com
# Date    : 2007-06-20

import _winreg

from ctypes import *

# MessageBox = windll.user32.MessageBoxA
# MessageBox(0, 'Welcome!', 'Hello', 0)

print ('正在修改IP，请稍后...')

netCfgInstanceID = None

hkey = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE, \
                       r'System\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}')

keyInfo = _winreg.QueryInfoKey(hkey)

# 寻找网卡对应的适配器名称 netCfgInstanceID
for index in range(keyInfo[0]):
    hSubKeyName = _winreg.EnumKey(hkey, index)
    hSubKey = _winreg.OpenKey(hkey, hSubKeyName)

    try:
        hNdiInfKey = _winreg.OpenKey(hSubKey, r'Ndi\Interfaces')
        lowerRange = _winreg.QueryValueEx(hNdiInfKey, 'LowerRange')

        # 检查是否是以太网
        if lowerRange[0] == 'ethernet':
            driverDesc = _winreg.QueryValueEx(hSubKey, 'DriverDesc')[0]
            # print 'DriverDesc: ', driverDesc
            netCfgInstanceID = _winreg.QueryValueEx(hSubKey, 'NetCfgInstanceID')[0]
            # print 'NetCfgInstanceID: ', netCfgInstanceID
            break

        _winreg.CloseKey(hNdiInfKey) # 关闭 RegKey
    except WindowsError:
        print (r'Message: No Ndi\Interfaces Key')

    # 循环结束，目前只提供修改一个网卡IP的功能
    _winreg.CloseKey(hSubKey)

_winreg.CloseKey(hkey)

if netCfgInstanceID == None:
    print '修改IP失败 - 没有找到网络适配器'    
    exit()

# print netCfgInstanceID

# 通过修改注册表设置IP
strKeyName = 'System\\CurrentControlSet\\Services\\Tcpip\\Parameters\\Interfaces\\' + netCfgInstanceID

# print strKeyName

hkey = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE, \
                       strKeyName, \
                       0, \
                       _winreg.KEY_WRITE)

# 定义需要修改的IP地址、子网掩码、默认网关和DNS等
ipAddress = ['192.168.1.135']
subnetMask = ['255.255.255.0']
gateway = ['192.168.1.10']
dnsServer = ['202.106.196.115', '202.106.0.20']

try:
    _winreg.SetValueEx(hkey, 'IPAddress', None, _winreg.REG_MULTI_SZ, ipAddress)
    _winreg.SetValueEx(hkey, 'SubnetMask', None, _winreg.REG_MULTI_SZ, subnetMask)
    _winreg.SetValueEx(hkey, 'DefaultGateway', None, _winreg.REG_MULTI_SZ, gateway)
    _winreg.SetValueEx(hkey, 'NameServer', None, _winreg.REG_SZ, ','.join(dnsServer))
except WindowsError:
    print 'Set IP Error'
    exit()

_winreg.CloseKey(hkey)

# 调用DhcpNotifyConfigChange函数通知IP被修改
DhcpNotifyConfigChange = windll.dhcpcsvc.DhcpNotifyConfigChange

inet_addr = windll.Ws2_32.inet_addr

# DhcpNotifyConfigChange 函数参数列表：
# LPWSTR lpwszServerName,  本地机器为None
# LPWSTR lpwszAdapterName, 网络适配器名称
# BOOL bNewIpAddress,      True表示修改IP
# DWORD dwIpIndex,         表示修改第几个IP, 从0开始
# DWORD dwIpAddress,       修改后的IP地址
# DWORD dwSubNetMask,      修改后的子码掩码
# int nDhcpAction          对DHCP的操作, 0 - 不修改, 1 - 启用, 2 - 禁用
DhcpNotifyConfigChange(None, \
                       netCfgInstanceID, \
                       True, \
                       0, \
                       inet_addr(ipAddress[0]), \
                       inet_addr(subnetMask[0]), \
                       0)

print '修改IP结束'
