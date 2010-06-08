#!/usr/bin/env python

"""
Check nginx status with stub_status module, compile nginx with:
--with-http_stub_status_module
configure nginx.config:
location /nginx-status {
  stub_status on;
  access_log  off;
}
"""
import re, sys, getopt, urllib

def main():
  try:
    opts, args = getopt.getopt(sys.argv[1:], "h", ["help", "url="])
  except getopt.GetoptError, err:
    # print help information and exit:
    print "UNKNOWN -", str(err) 
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
  if url == None:
    print "UNKNOWN - no 'url' argument"
    sys.exit(2)
  try:
    data = get_data(url)
    summary = data[0]
    metrics = data[1]
    print "OK -", summary, "|", ",".join([name + "=" + val for (name, val) in metrics])
  except:
    print "CRITICAL - failed to read status page"
    sys.exit(2)

def usage():
  print "Usage: check_nginx_status --url=url"

def get_data(url):
    data = urllib.urlopen(url)
    data = data.read()
    result = []

    match1 = re.search(r'Active connections:\s+(\d+)', data)
    match2 = re.search(r'\s*(\d+)\s+(\d+)\s+(\d+)', data)
    match3 = re.search(r'Reading:\s*(\d+)\s*Writing:\s*(\d+)\s*'
        'Waiting:\s*(\d+)', data)
    if not match1 or not match2 or not match3:
        raise Exception('Unable to parse %s' % url)
    summary = "Active connections = " + match1.group(1)
    return (summary, [('connections', match1.group(1)),
     ('accepted', match2.group(1)),
     ('handled', match2.group(2)),
     ('requests', match2.group(3)),
     ('reading', match3.group(1)),
     ('writing', match3.group(2)),
     ('waiting', match3.group(3))])

if __name__ == "__main__":
  main()
