#!/usr/bin/env lua

-- check linux load
-- author: ery.lee@gmail.com from monit.cn

dofile("plugin.lua")

function check()
  local output = os.cmd("cat /proc/loadavg")
  local load1,load5,load15 = string.match(output, "^([0-9]+.[0-9]+)%s([0-9]+.[0-9]+)%s([0-9]+.[0-9]+)")
  local summary = string.format("load1 = %s%%, load5 = %s%%, load15 = %s%%", load1, load5, load15)
  print("OK - "..summary.."\r\n")
  print("metric: load1="..load1.."%")
  print("metric: load5="..load5.."%")
  print("metric: load15="..load15.."%")
end

function usage()
  print("Usage: check_load")
end

ok, err = pcall(check)
if not ok then
  print("UNKNOWN - plugin internal error\r\n")
  print(err)
end
