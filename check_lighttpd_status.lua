#!/usr/bin/env lua

-- check lighttpd status
-- author: ery.lee@gmail.com from monit.cn

dofile("plugin.lua")

local METRICTAB = {
    ["Total Accesses"] = "total_accesses", 
    ["Total kBytes"] = "total_kbytes",
    ["Uptime"] = "uptime",
    ["BusyServers"] = "busy_servers",
    ["IdleServers"] = "idle_servers"}

-- do check
function check(opts) 
  local http = require("socket.http")
  http.TIMEOUT = 8
  local b,c,h,s = http.request(opts["url"])
  if not b then
    print("CRITICAL - "..status.."\r\n")
    return
  end
  if c ~= 200 then
    print("WARNING - "..s.."\r\n")
    return
  end
  if not string.find(b, "^Total Accesses:") then
    print("WARNING - invalid body content\r\n")
    return
  end
  local metrics = {}
  lines = string.split(b, "[\r\n]+")
  for _,line in pairs(lines) do
    kv = string.split(line, "[:%s]+")
    if METRICTAB[kv[1]] then
      metrics[METRICTAB[kv[1]]] = kv[2]
    end
  end
  print(string.format("OK - total accesses = %s, total kbytes = %s", metrics["total_accesses"], metrics["total_kbytes"]))
  print("count-metrics: total_accesses,total_kbytes\r\n")
  for k,v in pairs(metrics) do
    print(string.format("metric: %s=%s", k, tonumber(v)))
  end
end

-- usage
function usage() 
  print("Usage: check_apache_status --url=URL")
end

-- parse arguments
opts = getopt(arg, {"url"})
if not opts["url"] then
  print("UNKNOWN - miss argument = 'url'\r\n")
  usage()
  return
end

ok, err = pcall(check, opts)
if not ok then
  print("UNKNOWN - plugin internal error\r\n")
  print(err)
end
