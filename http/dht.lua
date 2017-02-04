-- DHT Data Service

-- local variables
local dht_pin = 3

-- function declarations
function readTemperature(dthPIN)
  local status, temp, humi, temp_dec, humi_dec = dht.read(dthPIN)
  
  local result = {0, 0}
  
  if status == dht.OK then
    -- Float firmware
    print("DHT Temperature:"..temp..";".."Humidity:"..humi)
    -- save values to the result
    result[1] = temp
    result[2] = humi

  elseif status == dht.ERROR_CHECKSUM then
      print( "DHT Checksum error." )
  elseif status == dht.ERROR_TIMEOUT then
      print( "DHT timed out." )
  end
  
  return result
end

local function makeResponseData()

  -- first, read data from DHT sensor
  temp_data = readTemperature(dht_pin)
  
  -- now, make the structure table
  local response = { 
    data = {
      temp = temp_data[1],
      humi = temp_data[2]
    },
    status = "OK",
    error = "N/A"
  }
  
  -- return it
  return response
end


return function (connection, req, args)
  dofile("httpserver-header.lc")(connection, 200, 'json')
  connection:send(cjson.encode(makeResponseData()))
end