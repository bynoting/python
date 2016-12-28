# -*- coding: cp936 -*-

# FileName: modify_ip.py
# Author  : qujinlong
# Email   : qujinlong123@gmail.com
# Date    : 2007-06-20

import _winreg

from ctypes import *

# MessageBox = windll.user32.MessageBoxA
# MessageBox(0, 'Welcome!', 'Hello', 0)

print ('�����޸�IP�����Ժ�...')

netCfgInstanceID = None

hkey = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE, \
                       r'System\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}')

keyInfo = _winreg.QueryInfoKey(hkey)

# Ѱ��������Ӧ������������ netCfgInstanceID
for index in range(keyInfo[0]):
    hSubKeyName = _winreg.EnumKey(hkey, index)
    hSubKey = _winreg.OpenKey(hkey, hSubKeyName)

    try:
        hNdiInfKey = _winreg.OpenKey(hSubKey, r'Ndi\Interfaces')
        lowerRange = _winreg.QueryValueEx(hNdiInfKey, 'LowerRange')

        # ����Ƿ�����̫��
        if lowerRange[0] == 'ethernet':
            driverDesc = _winreg.QueryValueEx(hSubKey, 'DriverDesc')[0]
            # print 'DriverDesc: ', driverDesc
            netCfgInstanceID = _winreg.QueryValueEx(hSubKey, 'NetCfgInstanceID')[0]
            # print 'NetCfgInstanceID: ', netCfgInstanceID
            break

        _winreg.CloseKey(hNdiInfKey) # �ر� RegKey
    except WindowsError:
        print (r'Message: No Ndi\Interfaces Key')

    # ѭ��������Ŀǰֻ�ṩ�޸�һ������IP�Ĺ���
    _winreg.CloseKey(hSubKey)

_winreg.CloseKey(hkey)

if netCfgInstanceID == None:
    print '�޸�IPʧ�� - û���ҵ�����������'    
    exit()

# print netCfgInstanceID

# ͨ���޸�ע�������IP
strKeyName = 'System\\CurrentControlSet\\Services\\Tcpip\\Parameters\\Interfaces\\' + netCfgInstanceID

# print strKeyName

hkey = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE, \
                       strKeyName, \
                       0, \
                       _winreg.KEY_WRITE)

# ������Ҫ�޸ĵ�IP��ַ���������롢Ĭ�����غ�DNS��
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

# ����DhcpNotifyConfigChange����֪ͨIP���޸�
DhcpNotifyConfigChange = windll.dhcpcsvc.DhcpNotifyConfigChange

inet_addr = windll.Ws2_32.inet_addr

# DhcpNotifyConfigChange ���������б�
# LPWSTR lpwszServerName,  ���ػ���ΪNone
# LPWSTR lpwszAdapterName, ��������������
# BOOL bNewIpAddress,      True��ʾ�޸�IP
# DWORD dwIpIndex,         ��ʾ�޸ĵڼ���IP, ��0��ʼ
# DWORD dwIpAddress,       �޸ĺ��IP��ַ
# DWORD dwSubNetMask,      �޸ĺ����������
# int nDhcpAction          ��DHCP�Ĳ���, 0 - ���޸�, 1 - ����, 2 - ����
DhcpNotifyConfigChange(None, \
                       netCfgInstanceID, \
                       True, \
                       0, \
                       inet_addr(ipAddress[0]), \
                       inet_addr(subnetMask[0]), \
                       0)

print '�޸�IP����'
