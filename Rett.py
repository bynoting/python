import re
#print( re.search(r'(\d)+','\d')  )

print re.search(r'(?P<g1>(\d)+)-(?P=g1)','134-134')
