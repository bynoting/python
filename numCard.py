# coding=utf-8
import os,sys
import re

numCard={'A1':'782','H1':'962','L1':'031','N1':'590','P1':'706','Q1':'043','T1':'890','U1':'326','V1':'440','Y1':'003',
         'A2':'608','H2':'060','L2':'680','N2':'862','P2':'906','Q2':'160','T2':'903','U2':'263','V2':'973','Y2':'795',
         'A3':'670','H3':'962','L3':'836','N3':'705','P3':'948','Q3':'967','T3':'006','U3':'841','V3':'583','Y3':'135',
         'A4':'188','H4':'094','L4':'206','N4':'808','P4':'498','Q4':'878','T4':'119','U4':'427','V4':'275','Y4':'674',
         'A5':'010','H5':'646','L5':'456','N5':'442','P5':'128','Q5':'929','T5':'183','U5':'678','V5':'843','Y5':'287',
         'A6':'909','H6':'797','L6':'814','N6':'382','P6':'500','Q6':'659','T6':'475','U6':'546','V6':'392','Y6':'339',
         'A7':'713','H7':'052','L7':'903','N7':'814','P7':'333','Q7':'086','T7':'072','U7':'976','V7':'556','Y7':'634',
         'A8':'882','H8':'357','L8':'277','N8':'154','P8':'809','Q8':'326','T8':'734','U8':'592','V8':'399','Y8':'766'
         }

patten = re.compile('^([ahlnpqtuvy|AHLNPQTUVY][0-9])+$')

userKey =input("Please Input :")

# 检验输入格式 是否为A1f9 格式
returnValue = patten.match(userKey)

if returnValue:
    pattenSub = re.compile('[ahlnpqtuvy|AHLNPQTUVY][0-9]')
    # 分解用户输入的keys：A1 ，f9
    numSubKeyList = pattenSub.findall(userKey)
    print(numSubKeyList)
    # 列表解析 很棒
    numList = [numCard[numSubKey.upper()] for numSubKey in numSubKeyList]
    userNum = ''.join(numList)

    print("the userNum is:%s"%userNum)
    #print(numCard[userNum.upper()])
else:
    print('Error Input!!!!!')
    exit