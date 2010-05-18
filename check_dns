#!/usr/bin/env python

"""
check_tcp
"""
import os, sys, getopt, socket

import time 

def run(args):
  name = args['name']
  if 'addrs' not in args:
    expected_addrs = []
  elif args['addrs'].strip() == '':
    expected_addrs = []
  else:
    expected_addrs = args['addrs'].split(',')
  start = time.time()
  #TODO: timeout
  pipe = os.popen("nslookup " + name)
  output = pipe.read()
  pipe.close
  lines = output.split("\n\n")
  if len(lines) < 2:
    print "UKNNOWN -", lines[0]
    return
  addrs = []
  addr_lines = lines[1].split("\n")
  for line in addr_lines:
    if "Address: "  in line:
      addr = line.strip("Address: ")
      addrs.append(addr)
  is_addr_valid = False
  if len(expected_addrs) == 0:
    is_addr_valid = True
  else: 
    for addr in addrs:
      if addr in expected_addrs:
        is_addr_valid = True
        break
  if is_addr_valid:
    escape_time = time.time() - start
    summary = "returns = '%s', response time = %.3f(s)" % (",".join(addrs), escape_time)
    metrics = "time=%.3fms" % (escape_time*1000)
    print "OK -", summary, "|", metrics
  else:
    print "CRITICAL - expected = '%s', got = '%s'" % (",".join(expected_addrs), ",".join(addrs))

def usage():
    print "Usage: check_dns -h --name=name --addr=addr1,addr2,..,addrn"

if __name__ == "__main__":
    try:
        opts, args = getopt.getopt(sys.argv[1:], "h", ["help", "name=", "addrs="])
    except getopt.GetoptError, err:
    # print help information and exit:
        print "UNKNOWN -", str(err)
        sys.exit(2)
    cmd_args = {} 
    for o, a in opts:
      if o in ("-h", "--help"):
        usage(),
        sys.exit(0)
      elif o in ("--name"):
        cmd_args['name'] = a
      elif o in ("--addrs"):
        cmd_args['addrs'] = a
      else:
        print "UNKNOWN - error argument:" + o
        usage()
        sys.exit(2)
    if not ('name' in cmd_args):
      print "UNKNOWN - invalid arguments"
      usage()
      sys.exit(2)
    try:
      run(cmd_args)
    except:
      print "UNKNOWN -", sys.exc_info()[0]
      sys.exit(2)

