-- lua plugin utilities

function filter(array, func)
  local new_array = {}
  for _,v in ipairs(array) do
    if func(v) then
      table.insert(new_array, v)
    end
  end
  return new_array
end

function map(array, func)
  local new_array = {}
  for i,v in ipairs(array) do
  new_array[i] = func(v)
  end
  return new_array
end

--string join
function join(tab, delimiter)
  return table.concat(tab, delimiter)
end

-- string split compatibility: Lua-5.1
function split(str, pat)
  local t = {}  -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
    table.insert(t,cap)
    end
    last_end = e+1
    s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
    cap = str:sub(last_end)
    table.insert(t, cap)
  end
  return t
end

-- run os command
function runcmd(cmd) 
  local tmp = os.tmpname()
  os.execute(cmd.." > "..tmp.." 2>&1")
  local f = assert(io.open(tmp, "r"))
  local output = f:read("*all")
  f:close()
  os.remove(tmp)
  return output
end

-- getopt, POSIX style command line argument parser
function getopt(arg, options )
  local tab = {}
  for k, v in ipairs(arg) do
    if string.sub( v, 1, 2) == "--" then
      local x = string.find( v, "=", 1, true )
      if x then tab[ string.sub( v, 3, x-1 ) ] = string.sub( v, x+1 )
      else      tab[ string.sub( v, 3 ) ] = true
      end
    elseif string.sub( v, 1, 1 ) == "-" then
      local y = 2
      local l = string.len(v)
      local jopt
      while ( y <= l ) do
        jopt = string.sub( v, y, y )
        if string.find( options, jopt, 1, true ) then
          if y < l then
            tab[ jopt ] = string.sub( v, y+1 )
            y = l
          else
            tab[ jopt ] = arg[ k + 1 ]
          end
        else
          tab[ jopt ] = true
        end
        y = y + 1
      end
    end
  end
  return tab
end

