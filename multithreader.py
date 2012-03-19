#!/usr/bin/python2.4
#/usr/bin/env python
# -*- coding: utf-8 -*-
#

"""
"""

#__title__ = "check_SNG_API"
#__version__ = "0.1"
#__changelog__ = "Now it can be configured on the fly to attack different SNG servers"
#__author__= "Xavi Carrillo"
#__email__= "xcarrillo at newbay dot com"

#debug = False

import sys, resource, os, math
#from optparse import OptionParser
import threading
import exceptions
e = exceptions.Exception


class myThread (threading.Thread):
    def __init__(self, threadID, number):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.number = number

    def run(self):
        print "Starting thread number %d\n" %(self.threadID)
        try:
            # numes funciona en 2.6: print math.factorial(self.number)
            print factor(self.number)
        except Exception, error:
            self.err = " failed: " + str(error)
        else:
            self.err = None
            
class Test:
    def __init__(self):
        self.contents = ''

    def body_callback(self, buf):
        self.contents = self.contents + buf

def exit(message, exitstatus):
    print message
    sys.exit(exitstatus)

#def run(command):
#    try:    
#        return subprocess.Popen(command, shell=True, stdout=subprocess.PIPE).stdout
#    except Exception, error:
#        exit("UNKNOWN: %s" %(error), 3)

                        
def factor(n):
    result = 1
    factor = 2
    while factor <= n:
        result *= factor
        factor += 1
    return result

    
def main():

    #    usage = "Usage: %prog [options]\n \n \
    #    It logs in a given MSISDN on a SNG server and performs actions against one or several Social Networks \n \n \
    #    Use --help to view options"
    #    parser = OptionParser(usage, version=__version__)
    #    parser.add_option("-m", "--msisdn", action="store", dest="MSISDN", type="string", default="0851181368",
    #                      help="Mobile phone number to register on a SNG server as a client.")
    #    
    #    (options, args) = parser.parse_args()
    #
    #    if options.debug:
    #        global debug
    #        debug = True

    
    ### Nomes funciona en +python2.6 ###
    #numberOfThreads = 3
    #threads = [myThread(i, 30000).start() for i in range(numberOfThreads)]
    #####################################
    
    threads = []
    thread1 = myThread(1, 30000)
    thread2 = myThread(2, 30000)
    thread1.start()
    thread2.start()
    threads.append(thread1)
    threads.append(thread2)

    # Wait for all threads to complete and check whether there was an exception or not.
    for t in threads:
        t.join()
        if t.err:
            exit("%s: %s" %("CRITICAL ", t.err), 2)
            
    # Evaluate:
    #print os.times().__doc__
    print "user time, system time, children's user time, children's system time, and elapsed real time since a fixed point in the past"
    print os.times()

    #print resource.getrusage(RUSAGE_BOTH)

    # If no exception was found we can safely exit with an OK
    #exit("OK - All tests passed successfully", 0)


if __name__ == "__main__":
    main()
