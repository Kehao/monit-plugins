#!/usr/bin/env lua

-- check mysql commands by "show global status like 'Bytes_%'"
-- author: ery.lee@gmail.com from monit.cn

dofile("plugin.lua")

require "luasql.mysql"

-- do check
function check(opts) 
  env = assert (luasql.mysql())
  con = assert (env:connect("mysql", opts["user"], opts["password"], opts["host"], tonumber(opts["port"])))
  -- retrieve status
  cur = assert (con:execute"show global status where Variable_name = 'Com_select' or Variable_name = 'Com_update' or Variable_name = 'Com_insert' or Variable_name = 'Com_delete';")
  row = cur:fetch ({}, "a")
  metrics = {}
  while row do
    metric = string.sub(row.Variable_name, string.len('Com_') + 1)
    metrics[metric] = row.Value
    row = cur:fetch (row, "a")
  end
  summaries = {}
  for k,v in pairs(metrics) do
    table.insert(summaries, string.format("%s = %s", k, v))
  end
  -- print result
  print("OK - "..string.join(summaries, ", "))
  print("count-metrics: select,update,insert,delete\r\n") 
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
  print("usage: check_mysql_cmd --host=Host --user=User --password=Password --port=Port")
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

