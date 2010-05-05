#!/usr/bin/python

"""
Check lighttpd status by mode_status, uncomment "mode_status" 
in lighttpd.conf:

server.modules = (
    "mod_access",
    "mod_status",
    "mod_accesslog" )

status.status-url = "/lighttpd-status"
"""
import re, sys, getopt, urllib

def main():
  try:
    opts, args = getopt.getopt(sys.argv[1:], "h", ["help", "url="])
  except getopt.GetoptError, err:
    # print help information and exit:
    print "UNKNOWN - " + str(err) 
    sys.exit(2)
  url = None
  for o, a in opts:
    if o in ("-h", "--help"):
      usage(),
      sys.exit(0)
    elif "--url" in o:
      url = a 
    else:
      print "UNKNOWN - error argument:" + o
      sys.exit(2)
  if url is None:
      print "UNKNOWN - could not parse arguments" 
      usage()
      sys.exit(2)
  try:
    data = get_data(url)
    summary = data[0]
    metrics = data[1]
    print "OK -", summary, "|", ",".join([name + "=" + val for (name, val) in metrics])
  except:
    print "UNKNOWN - internal error"
    sys.exit(2)
    

def usage():
  print "Usage: check_lighttpd_status -url=url"

def get_data(url):
    data = urllib.urlopen(url)
    data = data.read()
    lines = data.split("\n")
    data = []
    summary = ""
    for line in lines:
      if "Total Accesses:" in line:
        totalAcc = line.strip(" Total Accesses:")
        summary += "total accesses = " + totalAcc
        data.append(("total_accesses", totalAcc))
      elif "Total kBytes:" in line:
        totalKB = line.strip(" Total kBytes:")
        totalB = int(totalKB) * 1024
        summary += "," + "total kbytes = " + totalKB + "(kB)"
        data.append(("total_bytes", str(totalB)))
      elif "Uptime:" in line:
        uptime = line.strip(" Uptime:")
        data.append(("uptime", uptime))
      elif "BusyServers:" in line:
        busysrv = line.strip(" BusyServers:")
        data.append(("busy_servers", busysrv))
      elif "IdleServers:" in line:
        idlesrv = line.strip(" IdleServers:")
        data.append(("idle_servers", idlesrv))
      elif "Scoreboard:" in line:
        pass
      else:
        pass
    return (summary,data)

if __name__ == "__main__":
  main()
