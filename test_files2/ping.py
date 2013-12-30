import spur, sys
shell = spur.LocalShell()

host = sys.argv[1]
cmd = 'ping -c 2 -q '+host
c = cmd.split(' ')
# print c
code = 0
s = ''
try:
	result = shell.run(c)
	s = result.output
	code = result.return_code
except:
	print 'No Connection'        #'Destination host is unreachable'
	exit()

if code is 0:
	# print s
	l = s.split('\n')
	last_line = l[len(l)-2]
	# print last_line
	arr = last_line.split('/')
	avg = arr[4]
	# print 'avg =',avg
	if float(avg) < 2:
		print 'good time', avg
	else:
		print 'avg too big', avg
else:
	print 'Error Code'
