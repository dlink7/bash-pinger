import time

c=0
while True:
 c+=1 
 f = open('tt.log','a')
 f.write(str(c))
 f.flush()
 f.close() 
 time.sleep(2)

