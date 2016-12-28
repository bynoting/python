def add(a,b,c):
	return a+ b + c

args=(8,9)

print add(3,*args)

from datetime import datetime,timedelta
ar = datetime.strptime('00:00:00',"%H:%M:%S")
ar = ar + timedelta(seconds=1)

print ar.strftime("%H:%M:%S")
print ( datetime.now()+ timedelta(seconds=1) ).strftime("%Y-%m-%d %H:%M:%S")

