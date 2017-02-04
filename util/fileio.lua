-- File I/O functions

function file_exists(file_name)
  local file_found=io.open(file_name, "r")      

  if file_found==nil then
    file_found=file_name .. " ... Error - File Not Found"
    return false
  else
    file_found=file_name .. " ... File Found"
    return true
  end
end