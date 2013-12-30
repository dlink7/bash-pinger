import spur, sys, time
shell = spur.LocalShell()

TIME_LIMIT = 3 #sec
REPEAT_LIMIT = 5
list_1 = [] # list of ips with return code 1
list_2 = [] #list of ips with return code 2


def log(txt):
    print txt
    now = time.strftime("%H:%M:%S %d-%m-%Y", time.localtime())
    try:
    	txt = str(txt)
    	txt +='\n'   
        fout = open("log/" + time.strftime("%d-%m-%Y", time.localtime()) + '.log', "a")
        fout.write(txt.encode('utf-8', 'replace'))
        fout.flush()
        fout.close()
    except Exception as e:
        print "Improper character found", e



def ping(ip):
	log( ip+'.'*3)
	cmd = 'ping -c 10 -q '+ip #10 pings take 10 sec
	code = 0
	s = ''
	try:
		result = shell.run(cmd.split(' '))
		s = result.output
		code = result.return_code
	except:
		log( 'no connection')
		return 1
	if code is 0:
		l = s.split('\n')
		last_line = l[len(l)-2]
		arr = last_line.split('/')
		avg = arr[4]
		if float(avg) < TIME_LIMIT:
			log( 'good time ('+avg+' ms)')
			return 0
		else:
			log( 'long time ('+avg+' ms)')
			return 2
	else:
		log( 'return code is error code')
		return 1


def get_repeated_values(l):
	s = set(l)
	r = []
	for e in s:
		rpt = l.count(e)
		log( 'repeat: '+str(rpt)+' ('+e+')')
		if rpt > REPEAT_LIMIT:
			r.append(e)
			# for x in xrange(rpt):
			# 	l.remove(e)
	return r


def erase_in_both(ip):
	global list_1, list_2
	for l in list_1:
		if l == ip:
			list_1.remove(l)
	for l in list_2:
		if l == ip:
			list_2.remove(l)



c = 0
while True:
	c+=1
	log( '\nStart '+str(c)+': '+'='*25)
	log( '[A]PINGING '+'='*10)
	f = open('ips.conf','r')
	for ip in f:
		if not ip.startswith('#'):
			ip = ip.strip()
			code = ping(ip) # 0 time ok, 1 no conn, 2 long time(slow)
			if code is 0:
				erase_in_both(ip)
			if code is 1:
				list_1.append(ip)
			if code is 2:
				list_2.append(ip)	

	log( '[B]CHECKING '+'='*10)
    # //////////check lists////////////
	list_1_ = get_repeated_values(list_1)
	list_2_ = get_repeated_values(list_2)

	s = ""
	if len(list_1_) == REPEAT_LIMIT:
		s+= ("\nno connection to : "+str(list_1_))
	if len(list_2_) == REPEAT_LIMIT:
		s+= ("\nlong time to ips: "+str(list_2_))

	if s!="":
		log( "SMS:"+s)
		# send_sms(str)

	log( 'sleeping...')	
	time.sleep(1)
	