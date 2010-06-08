#!/usr/bin/env python

"""
check_task_top by 'top -b -n 1'
"""
import os, re, sys, getopt

def run(args):
    if 'darwin' in sys.platform:
      #mac os x
      pipe = os.popen('top -l 1')
    else:
      #linux
      pipe = os.popen('top -b -n 1')
    output = pipe.read()
    pipe.close
    lines = output.split("\n")
    if len(lines) < 3:
      print "UNKNOWN - unknown command output"
      return
    if 'darwin' in sys.platform:
      #mac os x
      taskinfo = lines[0]
      match = re.search(r'Processes:\s+([0-9]+)\s+total,\s+([0-9]+)\s+running,\s+[0-9]+\s+stuck,\s+([0-9]+)\s+sleeping', taskinfo)
    else:
      #linux
      taskinfo = lines[1]
      match = re.search(r'Tasks:\s+([0-9]+)\s+total,\s+([0-9]+)\s+running,\s+([0-9]+)\s+sleeping', taskinfo)
    if match == None:
      print "UNKNOWN -", taskinfo
    else:
      data = {'total': match.group(1), 'running': match.group(2), 'sleeping': match.group(3)}
      metrics = ",".join([name + '=' + val for name, val in data.iteritems()])
      print "OK - total =", match.group(1), "|", metrics

def usage():
    print "Usage: check_task_top -h"

if __name__ == "__main__":
    try:
        opts, args = getopt.getopt(sys.argv[1:], "h", ["help"])
    except getopt.GetoptError, err:
        print "UNKNOWN -", str(err)
        usage()
        sys.exit(2)
    for o, a in opts:
      if o in ("-h", "--help"):
        usage(),
        sys.exit(0)
      else:
        print "UNKNOWN - error argument:" + o
        usage()
        sys.exit(2)
    try:
      run({})
    except:
      print "UNKNOWN -", sys.exc_info()[0]
      sys.exit(2)

