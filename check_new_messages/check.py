#!/usr/bin/python2.7
# -*- coding: utf-8 -*-

import urllib, os, subprocess, time
from daemon import runner

URL = 'http://51t.ru/list.txt?h=1&el='
ECHO = 'ii.14/pipe.2032'
MSGS_LST = '/var/tmp/check_new_msgs.lst'
#ECHO = '/'.join(os.listdir('echo'))

class Check():

    def __init__(self):
        self.stdin_path = '/dev/null'
        self.stdout_path = '/dev/null' # or /dev/tty for debug
        self.stderr_path = '/dev/null'
        self.pidfile_path =  '/tmp/check_new_msgs.pid'
        self.pidfile_timeout = 5

    def run(self):
        while True:
            try:
                hashes = getf(URL+ECHO)
            except:
                time.sleep(10)
                continue
            oldhash = open(MSGS_LST).read().splitlines() if os.path.exists(MSGS_LST) else []
            check_hashes(hashes, oldhash)
            time.sleep(600)

def getf(l):
    return urllib.urlopen(l).read()


def sendmessage(message):
    subprocess.Popen(['notify-send', message])
    return


# Check hashes
def check_hashes(hashes, oldhash):
    for n in hashes.splitlines():
        ea,cnt,hsh = n.split(':',2)
        check = [x for x in oldhash if x.startswith(ea + ':')]
        if check:
            echoes = check[0].split(':',2)
            if not echoes[2].startswith('hsh/'):
                print 'error hsh: ' % ea
            elif echoes[2] != hsh:
                print ea
                sendmessage("ii\nНовые сообщения в\n"+ea)
        else:
            print ea
            sendmessage("ii\nНовые сообщения в\n"+ea)

    open(MSGS_LST,'w').write(hashes)

app = Check()
daemon_runner = runner.DaemonRunner(app)
daemon_runner.do_action()
