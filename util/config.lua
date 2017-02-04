-- Configuration settings management
-- dofile("fileio.lua")

function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, "{\n");
        table.insert(sb, table_print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("\"%s\"\n", tostring(value)))
      else
        table.insert(sb, string.format(
            "%s = \"%s\"\n", tostring (key), tostring(value)))
       end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

function to_string( tbl )
    if  "nil"       == type( tbl ) then
        return tostring(nil)
    elseif  "table" == type( tbl ) then
        return table_print(tbl)
    elseif  "string" == type( tbl ) then
        return tbl
    else
        return tostring(tbl)
    end
end

function get_settings()
  
  local config_file = "conf/config.json"
  local local_config_file = "conf/local.config.json"
  
  -- okay, let's read the JSON config file
  -- first, let's try to read settings from local config file (the one that is ignored by GIT)
  fd = file.open(local_config_file, "r") 
  if fd then
    print("INFO: We've found local configuration file "..local_config_file..". Loading data from it!")
    c_json = fd:read()
    fd:close()
    fd = nil
  else
    fd = file.open(config_file, "r")
    if fd then
      print("INFO: Loading configuration from "..config_file..".")
      c_json = fd:read()
      fd:close()
      fd = nil
    else
      print("Neither "..config_file.." not "..local_config_file.." exist or we just cannot open it!")
      return nil
    end
  end
  
  -- let's put JSON to work
  json_table = cjson.decode(c_json)
  print(to_string(json_table))
  
  -- return the value you need
  return json_table

end