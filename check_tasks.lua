#!/usr/bin/env lua

-- check linux task

dofile("plugin.lua")

function check() 
  output = os.cmd('top -b -n 1')
  metrics = {string.match(output, "Tasks:%s+([0-9]+)%s+total,%s+([0-9]+)%s+running,%s+([0-9]+)%s+sleeping")}
  if #metrics < 3 then
    print("UNKNOWN - unknown command output\r\n")
    print(output)
    return
  end
  print("OK - total = "..metrics[1].."\r\n")
  print("metric: total="..metrics[1])
  print("metric: running="..metrics[2])
  print("metric: sleeping="..metrics[3])
end

function usage()
  print("Usage: check_task")
end

ok, err = pcall(check)
if not ok then
  print("UNKNOWN - plugin internal error\r\n")
  print(err)
end
