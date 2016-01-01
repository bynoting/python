#coding=gbk
'''
Created on 2013-4-6

@author: liqiang
'''
import socket  

print ("Creating socket....")
# socket.socket??Э??,??????? ????socket????  
# socket.AF_INET???PIV4Э?飻  
# socket.SOCK_STREAM TCP?????  
# socket.SOCK_DGTAM UDP?????  

# ?????????: IP,port  
try:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  
    print ('Done' ) 
    print ('Connecting to remote host...' ) 
    s.connect(("58.30.23.7", 8090)) 
    print("connect is ok") 
    '''
    except socket.error as e:  
        print ('Connection error:%s' % e[0])       
    '''
except Exception as ex:
    print('error msg is :%s'%ex)   
finally:
    print ('done.' )

