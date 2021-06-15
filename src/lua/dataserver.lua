
--[[
    "Event loop" for a data server:
        - Receive poll from main computer
        - Send back peripheral data as a table, or apply received action
]]

local netutils = require "netutils"

settings.load()
term.clear()

local peripheralType = settings.get("ccmreactor.peripheral_type")

local periph = peripheral.wrap(settings.get("ccmreactor.peripheral_side"))

local modem = netutils.setupModem()
local hostname

if settings.get("ccmreactor.hostname_allocation") == "static" then
    hostname = peripheralType.."_"..settings.get("ccmreactor.hostname_static_id")
else
    hostname = netutils.getAvailableHostname(peripheralType)
end

rednet.host(netutils.protocol, hostname)

print("Listening for requests as hostname: "..hostname)
print("Server type: "..settings.get("ccmreactor.peripheral_type"))
print("Peripheral side: "..settings.get("ccmreactor.peripheral_side"))

while true do 
    
    local id, msg = rednet.receive(netutils.protocol)
    
    if msg == "get" then
        
        rednet.send(id, netutils.compileGetters(periph), netutils.protocol)
        
    elseif msg == "health_check" then
        
        rednet.send(id, true, netutils.protocol)
        
    elseif msg == "activate" and peripheralType == "reactor" then
        periph.activate()
    elseif msg == "scram" and peripheralType == "reactor" then
        periph.scram()
    elseif msg.action == "set_burn_rate" and peripheralType == "reactor" then
        periph.setBurnRate(msg.burnrate)
    end
    
end
