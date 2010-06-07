#!/usr/bin/env lua

-- scan_nmap

dofile("plugin.lua")

-- do check
function scan(opts) 
  local output = runcmd("nmap -F -sU -sT --host-timeout 20000 "..opts["host"])
  local patten = "^(%d+)/([tcudp]+)%s+([%w|]+)%s+([%w%-]+)$"
  local lines = split(output, "[\r\n]+")
  local entries = {}
  for _,line in pairs(lines) do
    _,_,port,proto,state,service = string.find(line, patten)
    if service then
      table.insert(entries, {port = port, proto = proto, state = state, service = service})
    end
  end
  local tcps = filter(entries, function(entry) return (entry.proto == "tcp") end)
  local udps = filter(entries, function(entry) return (entry.proto == "udp") end)

  local tcp_ports = map(tcps, function(tcp) return tcp.port end)  
  local udp_ports = map(udps, function(udp) return udp.port end)

  print("OK - tcp ports = "..join(tcp_ports, "|")..", udp ports = "..join(udp_ports, "|").."\r\n")
  for _,entry in pairs(entries) do
    print(string.format("entry: port=%s/%s,state=%s,service=%s", 
        entry.port, entry.proto, entry.state, entry.service))
  end
  -- match = re.search(r'^(\d+/[udtcp]+)\s', line)
end

-- usage
function usage() 
  print("Usage: scan_nmap --host=Host")
end

-- parse arguments
opts = getopt(arg, {"host"})
if not opts["host"] then
  print("UNKNOWN - miss argument = 'host'\r\n")
  usage()
  return
end

ok, err = pcall(scan, opts)
if not ok then
  print("UNKNOWN - plugin internal error\r\n")
  print(err)
end
