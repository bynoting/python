# -*- coding: cp936 -*-

# FileName: modify_ip(wmi).py
# Author  : qujinlong
# Email   : qujinlong123@gmail.com
# Date    : 2007-06-21

import wmi

print ('�����޸�IP�����Ժ�...')

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
    print ('û���ҵ����õ�����������')
    exit()

# ��ȡ��һ������������������
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
    print ('  �ɹ�����IP')
elif returnValue[0] == 1:
    print ('  �ɹ�����IP')
    intReboot += 1
else:
    print ('�޸�IPʧ��(IP���÷�������)%d' % returnValue[0])
    exit()

returnValue = objNicConfig.SetGateways(DefaultIPGateway = arrDefaultGateways, GatewayCostMetric = arrGatewayCostMetrics)
if returnValue[0] == 0:
    print ('  �ɹ���������')
elif returnValue[0] == 1:
    print ('  �ɹ���������')
    intReboot += 1
else:
    print ('�޸�IPʧ��(�������÷�������)')
    exit()

returnValue = objNicConfig.SetDNSServerSearchOrder(DNSServerSearchOrder = arrDNSServers)
if returnValue[0] == 0:
    print ('  �ɹ�����DNS')
elif returnValue[0] == 1:
    print ('  �ɹ�����DNS')
    intReboot += 1
else:
    print ('�޸�IPʧ��(DNS���÷�������)')
    exit()

if intReboot > 0:
    print ('��Ҫ�������������')
else:
    print ('')
    print ('  �޸ĺ������Ϊ��')
    print ('  IP: ', ', '.join(objNicConfig.IPAddress))
    print ('  ����:', ', '.join(objNicConfig.IPSubnet))
    print ('  ����:', ', '.join(objNicConfig.DefaultIPGateway))
    print ('  DNS:', ', '.join(objNicConfig.DNSServerSearchOrder))

print ('�޸�IP����')
