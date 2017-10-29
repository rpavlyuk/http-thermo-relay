-- Modules
require "util.helpers"

-- GPIO's of the relay array
local action = "turn-on"
local active_relay = 1
local relays = { 1, 0 }

local function turn_on(relay)
 
 local pin = relays[relay]
 
 print("INFO: Turn-on action initiated for relay "..active_relay.." on pin "..pin)
 
 gpio.mode(pin, gpio.OUTPUT)
 gpio.write(pin, gpio.HIGH)

end

local function turn_off(relay)
 
 local pin = relays[relay]
 
 print("INFO: Turn-off action initiated for relay "..active_relay.." on pin "..pin)

 gpio.mode(pin, gpio.OUTPUT)
 gpio.write(pin, gpio.LOW)
 gpio.mode(pin, gpio.INPUT)

end

return function (connection, req, args)
  dofile("httpserver-header.lc")(connection, 200, 'json')
  
  print_r(args)
  
  if args.relay then
    active_relay = tonumber(args.relay)
  end
  
  if args.action then
    action = args.action
  end
  
  if action == "turn-on" then
    print("DEBUG: turn-on")
    turn_on(active_relay)
  elseif action == "turn-off" then
    print("DEBUG: turn-off")
    turn_off(active_relay)
  end
  
  
end