#!/usr/bin/env lua

-- check mysql traffic by "show global status like 'Bytes_%'"

dofile("plugin.lua")

require "luasql.mysql"

-- do check
function check(opts) 
  env = assert (luasql.mysql())
  con = assert (env:connect("mysql", opts["user"], opts["password"], opts["host"], tonumber(opts["port"])))
  -- retrieve status
  cur = assert (con:execute"show global status where Variable_name = ‘Bytes_received’ or Variable_name = ‘Bytes_sent’")
  row = cur:fetch ({}, "a")
  metrics = {}
  while row do
    metric = string.sub(row.Variable_name, string.len('Bytes_') + 1)
    metrics[metric] = row.Value
    row = cur:fetch (row, "a")
  end
  -- print result
  print(string.format("OK - sent = %s, received = %s", metrics["sent"], metrics["received"]))
  print("count-metrics: sent,received\r\n") 
  for k,v in pairs(metrics) do
    print(string.format("metric: %s=%s", k, v))
  end
  -- close everything
  cur:close()
  con:close()
  env:close()
end

-- usage
function usage() 
  print("usage: check_mysql_bytes --host=Host --user=User --password=Password --port=Port")
end

-- parse arguments
opts = getopt(arg, {"host", "password", "user", "port"})
if not opts["port"] then opts["port"] = "3306" end
for i, o in ipairs({"host", "password", "user"}) do
  if not opts[o] then
    print(string.format("UNKNOWN - miss argument = '%s'\r\n", o))
    usage()
    return
  end
end

status, err = pcall(check, opts) 
if not status then
  print("UNKNOWN - plugin internal error\r\n")
  print(err)
end

