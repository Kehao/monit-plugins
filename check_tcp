#!/usr/bin/env python

"""
check_tcp
"""
import sys, getopt, socket

import time 

def run(args):
    host = args['host']
    port = args['port']
    s = None
    try:
      start = time.time()
      s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
      s.settimeout(5)
      s.connect((host, int(port)))
      escape_time = time.time() - start
      summary = "port = %s, response time = %.3f(s)" % (port, escape_time)
      metrics = "time=%.3fms" % (escape_time*1000)
      print "OK -", summary, "|", metrics
    except socket.error, msg:
      print "CRITICAL -", msg
    if s is not None:
      s.close()

def usage():
    print "Usage: check_ping -h --host=host --port=port"

if __name__ == "__main__":
    try:
        opts, args = getopt.getopt(sys.argv[1:], "h", ["help", "host=", "port="])
    except getopt.GetoptError, err:
    # print help information and exit:
        print "UNKNOWN -", str(err)
        sys.exit(2)
    cmd_args = {} 
    for o, a in opts:
      if o in ("-h", "--help"):
        usage(),
        sys.exit(0)
      elif o in ("--host"):
        cmd_args['host'] = a
      elif o in ("--port"):
        cmd_args['port'] = a
      else:
        print "UNKNOWN - error argument:" + o
        usage()
        sys.exit(2)
    if not ('host' in cmd_args and 'port' in cmd_args):
      print "UNKNOWN - invalid arguments"
      usage()
      sys.exit(2)
    try:
      run(cmd_args)
    except:
      print "UNKNOWN -", sys.exc_info()[0]
      sys.exit(2)

