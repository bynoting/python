# -*- coding: cp936 -*-

# FileName: modify_ip(wmi).py
# Author  : qujinlong
# Email   : qujinlong123@gmail.com
# Date    : 2007-06-21

import wmi

print ('正在修改IP，请稍后...')

wmiService = wmi.WMI()

colNicConfigs = wmiService.Win32_NetworkAdapterConfiguration(IPEnabled = True)

#for objNicConfig in colNicConfigs:
#    print objNicConfig.Index
#    print objNicConfig.SettingID
#    print objNicConfig.Description
#    print objNicConfig.IPAddress
#    print objNicConfig.IPSubnet
#    print objNicConfig.DefaultIPGateway
#    print objNicConfig.DNSServerSearchOrder

if len(colNicConfigs) < 1:
    print ('没有找到可用的网络适配器')
    exit()

# 获取第一个网络适配器的设置
objNicConfig = colNicConfigs[0]

#for method_name in objNicConfig.methods:
#   method = getattr(objNicConfig, method_name)
#   print method

arrIPAddresses = ['192.168.1.136']
arrSubnetMasks = ['255.255.0.0']
arrDefaultGateways = ['192.168.1.1']
arrGatewayCostMetrics = [1]
arrDNSServers = ['192.168.1.3', '202.106.46.151', '202.106.0.20']
intReboot = 0

returnValue = objNicConfig.EnableStatic(IPAddress = arrIPAddresses, SubnetMask = arrSubnetMasks)
if returnValue[0] == 0:
    print ('  成功设置IP')
elif returnValue[0] == 1:
    print ('  成功设置IP')
    intReboot += 1
else:
    print ('修改IP失败(IP设置发生错误)%d' % returnValue[0])
    exit()

returnValue = objNicConfig.SetGateways(DefaultIPGateway = arrDefaultGateways, GatewayCostMetric = arrGatewayCostMetrics)
if returnValue[0] == 0:
    print ('  成功设置网关')
elif returnValue[0] == 1:
    print ('  成功设置网关')
    intReboot += 1
else:
    print ('修改IP失败(网关设置发生错误)')
    exit()

returnValue = objNicConfig.SetDNSServerSearchOrder(DNSServerSearchOrder = arrDNSServers)
if returnValue[0] == 0:
    print ('  成功设置DNS')
elif returnValue[0] == 1:
    print ('  成功设置DNS')
    intReboot += 1
else:
    print ('修改IP失败(DNS设置发生错误)')
    exit()

if intReboot > 0:
    print ('需要重新启动计算机')
else:
    print ('')
    print ('  修改后的配置为：')
    print ('  IP: ', ', '.join(objNicConfig.IPAddress))
    print ('  掩码:', ', '.join(objNicConfig.IPSubnet))
    print ('  网关:', ', '.join(objNicConfig.DefaultIPGateway))
    print ('  DNS:', ', '.join(objNicConfig.DNSServerSearchOrder))

print ('修改IP结束')
