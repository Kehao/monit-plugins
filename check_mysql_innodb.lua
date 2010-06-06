#!/usr/bin/env lua
"""
Check mysql innodb by "show status like 'Innodb_%'"
"""

require "luasql.mysql"

-- create environment object
env = assert (luasql.mysql())
-- connect to data source
con = assert (env:connect("mysql", "root", "public"))
-- retrieve a cursor
cur = assert (con:execute"show global status like 'Innodb_%'")
-- print all rows, the rows will be indexed by field names
row = cur:fetch ({}, "a")
while row do
  print(string.format("metric: %s=%s", row.Variable_name, row.Value))
  -- reusing the table of results
  row = cur:fetch (row, "a")
end
-- close everything
cur:close()
con:close()
env:close()

