
-- 3x3 monitor size is 57w by 38h

--[[
    "Event loop" for the main computer:
        - Poll the peripheral "data servers"
        - Update GUI
            - Get GUI events? (user interaction)
        - Poll webserver (new.vedat.xyz)
            - If applicable, process user events?
]]

local gui = require "guiutils"
local netutils = require "netutils"
local monitor = peripheral.find("monitor")

term.clear()
monitor.setTextScale(1)
monitor.clear()

gui.addText(monitor, "Right-click anywhere", 2, 10, colors.white)
gui.addText(monitor, "to start...", 2, 11, colors.white)
os.pullEvent("monitor_touch")

monitor.setTextScale(0.5)
monitor.clear()

local mainWindow = window.create(monitor, 2, 2, 36, 27)
local tabWindow = window.create(monitor, 39, 2, 18, 36)
local optionsWindow = window.create(monitor, 2, 30, 36, 8)

gui.drawWindowBorder(mainWindow, colors.green, "Current Tab")
gui.drawWindowBorder(optionsWindow, colors.red, "Options")
gui.drawWindowBorder(tabWindow, colors.gray, "Tabs")

print("Setting up modem")
netutils.setupModem()

print("Getting all data server ids")
local maxTypeId = settings.get("ccmreactor.peripheral_type_max_qty")
local servers = netutils.getServers("ALL", maxTypeId)
local activeTab = 1
local activeTabData
local visibleindex = 1

local function dataServerEvents ()
    
    while true do
        
        activeTabData = netutils.requestGetter(servers[activeTab].id)
        
        os.sleep(2)
        
    end
    
end

local function drawGUI ()
    
    while true do
        
        if activeTabData ~= nil and next(activeTabData) ~= nil then
            
            gui.drawTablist(tabWindow, servers, visibleindex)
            
            gui.drawMainTab(mainWindow, activeTabData, servers[activeTab])
            
            if servers[activeTab].hosttype == "reactor" then
                gui.drawOptionsTab(optionsWindow, activeTabData)
            else
                gui.drawWindowBorder(optionsWindow, colors.red, "Options")
            end
            
        end
        
        os.sleep(1)
        
    end
    
end

local function initButtonEvents ()
    
    local event, id, x, y = os.pullEvent("monitor_touch")
    x = x + 1
    y = y + 1
    
    local action, value = gui.processTablistEvent(x, y, tabWindow, servers, visibleindex)
    
    if action == "tab_select" and value <= #servers then
        activeTab = value
        activeTabData = netutils.requestGetter(servers[activeTab].id)
    elseif action == "scroll" then
        visibleindex = value
    end
    
    if action == nil and servers[activeTab].hosttype == "reactor" then
        
        action, value = gui.processOptionsEvent(x, y, optionsWindow, activeTabData)
        
        if action == "change_status" then
            netutils.sendReactorStatusChange(servers[activeTab].id, value)
        elseif action == "set_burn_rate" then
            netutils.sendBurnRateChange(servers[activeTab].id, value)
        end
        
    end
    
end

local ws

local function initWebClientEvents ()
    
    if ws ~= nil then
        
        local msg = ws.receive()
        
        if msg == "get_data" then
            ws.send(textutils.serializeJSON({
                allServers = servers,
                server = servers[activeTab],
                data = activeTabData,
            }))
        end
        
    else
        
        print("Opening web socket...")
        ws = netutils.openWebSocket()
        
    end
    
end

print("Starting event loop")
while true do
    
    if servers == nil or next(servers) == nil then
        servers = netutils.getServers("ALL", maxTypeId)
        os.sleep(2)
    else
        parallel.waitForAny(
            dataServerEvents,
            drawGUI,
            initButtonEvents,
            initWebClientEvents
        )
    end
    
end
