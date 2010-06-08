#!/usr/bin/env lua

-- check_dns

dofile("plugin.lua")

-- do check
function check(opts) 
  expected_addrs = split(opts["addrs"], ",")
  start_time = os.time()
  output = runcmd("nslookup " + opts["name"])
  end_time = os.time()
  lines = split(output, "[\r\n]+")
  if table.getn(lines) < 2 then
    print("UNKNOWN - "..lines[1])
    return
  end
  addrs = {}
  addr_lines = split(lines[2], "[\r\n]+")
  for k,line in pairs(addr_lines) do
    _,_,addr = string.find(line, "Address:%s+([%d%.]+)")
    if addr then table.insert(addrs, addr) end
  end
  print("metric: time="..(end_time - start_time).."s")
end

-- usage
function usage() 
  print("Usage: check_dns --name=Domain --addrs=Ip,Ip")
end

-- parse arguments
opts = getopt(arg, {"name", "addrs"})
opts["addrs"] = opts["addrs"] or ""
if not opts["name"] then
  print("UNKNOWN - miss argument = 'name'\r\n")
  usage()
  return
end

ok, err = pcall(check, opts)
if not ok then
  print("UNKNOWN - plugin internal error\r\n")
  print(err)
end
