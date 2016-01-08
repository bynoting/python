# coding='gbk'
import os
import os.path
for root, dirs, files in os.walk('F:\\svn\\����֧��\\��˾��Ʒ\\GTVM'):
    for file in files:
        print os.path.join(root, file)


raw_input('good')

