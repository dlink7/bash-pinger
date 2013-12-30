import urllib2, base64

import os,sys, shutil,subprocess

from zipfile import ZipFile, ZipInfo

import zipfile



username = 'Leul'

password = 'Better123'

binary = 'https://raw.github.com/jayakrishnag/iTunesDownloader/master/Binary/'

iTunesDownloader = 'iTunesDownloader.zip'

dialogHandler = 'DialogHandler.zip'

dsk = 'C:\\Users\\administrator\\Desktop\\'

dcm = 'C:\\Users\\administrator\\Documents\\'



###################################################

def unzip(zipFilePath, destDir):

    zfile = zipfile.ZipFile(zipFilePath)

    for name in zfile.namelist():

        (dirName, fileName) = os.path.split(name)

        if fileName == '':

            # directory

            newDir = destDir + '/' + dirName

            if not os.path.exists(newDir):

                os.mkdir(newDir)

        else:

            # file

            fd = open(destDir + '/' + name, 'wb')

            fd.write(zfile.read(name))

            fd.close()

    zfile.close()

###################################################



print('deleting...')

l = os.listdir(dsk)

if 'Release' in l:

    shutil.rmtree(dsk+'Release')



l = os.listdir(dcm)

if 'DialogHandler' in l:

    shutil.rmtree(dcm+'DialogHandler')



print('downloading...')

auth_encoded = base64.encodestring('%s:%s' % (username, password))[:-1]



req = urllib2.Request(binary+iTunesDownloader)

req.add_header('Authorization', 'Basic %s' % auth_encoded)

f = open(dsk+iTunesDownloader,'wb')

response = urllib2.urlopen(req).read()

f.write(response)

f.close()



req = urllib2.Request(binary+dialogHandler)

req.add_header('Authorization', 'Basic %s' % auth_encoded)

f = open(dsk+dialogHandler,'wb')

response = urllib2.urlopen(req).read()

f.write(response)

f.close()





print('Unzipping...')

unzip(dsk+iTunesDownloader,dsk)

unzip(dsk+dialogHandler,dcm)



print('deleting zip...')

os.remove(dsk+iTunesDownloader)

os.remove(dsk+dialogHandler)



print 'checking...'

l = os.listdir(dcm)

if 'logFile.txt' not in l:

    shutil.copy2(dsk+'Release\\logFile.txt',dcm)

if 'config.txt' not in l:

    shutil.copy2(dsk+'Release\\config.txt',dcm)

    

#print('launching...')

#os.system(os.path.join("Release","test1.exe"))

print('Done')

exit()
