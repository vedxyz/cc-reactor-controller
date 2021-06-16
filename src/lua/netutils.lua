
local protocol = "ccmekanismreactor"
local defaultMaxTypeId = 6

local function getAvailableHostname (hosttype)
    
    for i = 1, defaultMaxTypeId do
        
        if rednet.lookup(protocol, hosttype.."_"..i) == nil then
            
            return hosttype.."_"..i
            
        end
        
    end
    
    return "ERR: HOSTS FULL"
    
end

local function compileGetters (periph)
    
    local getters = {}
    
    for key, func in pairs(periph) do
        
        if string.sub(key, 1, 3) == "get" then
            getters[string.sub(key, 4)] = func()
        end
        
    end
    
    return getters
    
end

local function requestGetter (dataserverid)
    
    rednet.send(dataserverid, "get", protocol)
    
    local id, msg = rednet.receive(protocol)
    
    return msg
    
end

local function isHostAlive (id)
    
    rednet.send(id, "health_check", protocol)
    
    local _id, msg = rednet.receive(protocol)
    
    return msg
    
end

local function getServers (hosttype, maxTypeId)
    
    if hosttype == "ALL" then
        return { 
            unpack(getServers("turbine", maxTypeId)), 
            unpack(getServers("imatrix", maxTypeId)), 
            unpack(getServers("reactor", maxTypeId)),
        }
    end
    
    local servers = {}
    
    for i = 1, maxTypeId or defaultMaxTypeId do
        
        local lookup = rednet.lookup(protocol, hosttype.."_"..i)
        
        if lookup ~= nil then
            
            table.insert(servers, { id = lookup, hostname = hosttype.."_"..i, hosttype = hosttype })
            
        end
        
    end
    
    return servers
    
end

local function setupModem ()
    
    return peripheral.find("modem", function (name, wrapped)
        if wrapped.isWireless() then
            rednet.open(name)
            return true
        end
    end)
    
end

local function sendReactorStatusChange (dataserverid, statusboolean)
    
    local message
    
    if statusboolean then
        message = "activate"
    else
        message = "scram"
    end
    
    rednet.send(dataserverid, message, protocol)
    
end

local function sendBurnRateChange (dataserverid, burnrate)
    
    rednet.send(dataserverid, { action = "set_burn_rate", burnrate = burnrate }, protocol)
    
end

local function openWebSocket ()
    
    return http.websocket("wss://new.vedat.xyz:3000/", { ["X-Is-CC-Computer"] = "true" })
    
end

return {
    protocol = protocol,
    getAvailableHostname = getAvailableHostname,
    compileGetters = compileGetters,
    requestGetter = requestGetter,
    getServers = getServers,
    setupModem = setupModem,
    sendReactorStatusChange = sendReactorStatusChange,
    sendBurnRateChange = sendBurnRateChange,
    isHostAlive = isHostAlive,
    openWebSocket = openWebSocket,
}
