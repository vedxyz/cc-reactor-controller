
local function addText (monitor, text, x, y, color, bgColor)
    
    monitor.setCursorPos(x, y)
    monitor.setTextColor(color)
    monitor.setBackgroundColor(bgColor or colors.black)
    
    monitor.write(text)
    
end

local function addKeyValuePair (monitor, x, y, key, value, valueColor)
    
    addText(monitor, key..": ", x, y, colors.white)
    
    addText(monitor, value, x + #key + 2, y, valueColor or colors.white)
    
end

local function drawBox (monitor, x, y, width, height, color)
    
    local prevTerm = term.redirect(monitor)
    
    paintutils.drawBox(x, y, x + width - 1, y + height - 1, color)
    monitor.setBackgroundColor(colors.black)
    
    term.redirect(prevTerm)
    
end

local function drawWindowBorder (window, color, title)
    
    window.setTextColor(colors.black)
    window.setBackgroundColor(colors.black)
    window.clear()
    
    local prevTerm = term.redirect(window)
    local width, height = window.getSize()
    
    paintutils.drawBox(1, 1, width, height, color)
    
    term.redirect(prevTerm)
    
    if title ~= nil then
        addText(window, " "..title.." ", 3, 1, color)
    end
    
end

local function formatItemName (name)
    
    return string.gsub(string.gsub(name, "(.*):", ""), "_", " ")
    
end

local function roundToPlaces (number, decimalplaces)
    
    if number == nil or decimalplaces == nil or tonumber(number) == nil then
        return nil
    end
    
    return math.floor( tonumber(number) * math.pow(10, decimalplaces) ) / math.pow(10, decimalplaces)
    
end

local function formatNumber (number, unit)
    
    local result = ""
    local numberStr = tostring(number)
    local digitOffset = #numberStr % 3
    
    for i = 1, #numberStr do
        
        result = result..string.sub(numberStr, i, i)
        
        if (i - digitOffset) % 3 == 0 and i ~= #numberStr then
            result = result..","
        end
        
    end
    
    if unit ~= nil then
        result = result.." "..unit
    end
    
    return result
    
end

local function formatImatrix (datatable)
    
    local result = {}
    
    result["Induction Providers"] = formatNumber(datatable.InstalledProviders)
    result["Induction Cells"] = formatNumber(datatable.InstalledCells)
    
    result["Energy"] = formatNumber(datatable.Energy, "FE")
    result["Capacity"] = formatNumber(datatable.MaxEnergy, "FE")
    
    result["Last Input"] = formatNumber(datatable.LastInput, "FE")
    result["Last Output"] = formatNumber(datatable.LastOutput, "FE")
    
    result["Max Transfer"] = formatNumber(datatable.TransferCap, "FE/t")
    
    return result
    
end

local function formatReactor (datatable)
    
    local result = {}
    
    result["Status"] = datatable.Status
    result["Set Burn Rate"] = datatable.BurnRate
    result["Actual Burn Rate"] = datatable.ActualBurnRate
    result["Max Burn Rate"] = datatable.MaxBurnRate
    
    result["Coolant Type"] = formatItemName(datatable.Coolant.name)
    result["Coolant Amount"] = formatNumber(datatable.Coolant.amount, "mB")
    result["Coolant Capacity"] = formatNumber(datatable.CoolantCapacity, "mB")
    result["Heated Coolant Type"] = formatItemName(datatable.HeatedCoolant.name)
    result["Heated Coolant Amount"] = formatNumber(datatable.HeatedCoolant.amount, "mB")
    result["Heated Coolant Capacity"] = formatNumber(datatable.HeatedCoolantCapacity, "mB")
    
    result["Fuel"] = formatNumber(datatable.Fuel, "mB")
    result["Fuel Capacity"] = formatNumber(datatable.FuelCapacity, "mB")
    result["Fuel Assemblies"] = formatNumber(datatable.FuelAssemblies)
    result["Fuel Surface"] = formatNumber(datatable.FuelSurfaceArea, "m2")
    
    result["Waste"] = formatNumber(datatable.Waste, "mB")
    result["Waste Capacity"] = formatNumber(datatable.WasteCapacity, "mB")
    
    result["Heating Rate"] = formatNumber(datatable.HeatingRate)
    result["Temperature"] = datatable.Temperature
    result["Max Temperature"] = formatNumber(datatable.HeatCapacity, "J/K")
    
    result["Damage Percent"] = datatable.DamagePercent
    result["Environmental Loss"] = datatable.EnvironmentalLoss
    
    result["Boil Efficiency"] = formatNumber(datatable.BoilEfficiency)
    
    return result
    
end

local function formatTurbine (datatable)
    
    local result = {}
    
    result["Dispersers"] = formatNumber(datatable.Dispersers)
    result["Condensers"] = formatNumber(datatable.Condensers)
    result["Blades"] = formatNumber(datatable.Blades)
    result["Vents"] = formatNumber(datatable.Vents)
    result["Coils"] = formatNumber(datatable.Coils)
    
    result["Steam"] = formatNumber(datatable.Steam, "mB")
    result["Capacity"] = formatNumber(datatable.SteamCapacity, "mB")
    result["Dumping Mode"] = datatable.DumpingMode
    
    result["Production Rate"] = formatNumber(datatable.ProductionRate, "FE/t")
    result["Max Production"] = formatNumber(datatable.MaxProduction, "FE/t")
    
    result["Flow Rate"] = formatNumber(datatable.FlowRate, "mB/t")
    result["Max Flow"] = formatNumber(datatable.MaxFlowRate, "mB/t")
    
    result["Max Water Output"] = formatNumber(datatable.MaxWaterOutput, "mB/t")
    
    return result
    
end

local function drawMainTab (window, datatable, hostdata)
    
    if datatable == nil then return end
    
    local tabtype = hostdata.hosttype
    local tabname
    local fTable
    
    if tabtype == "imatrix" then
        fTable = formatImatrix(datatable)
        tabname = "Induction Matrix #"
    elseif tabtype == "turbine" then
        fTable = formatTurbine(datatable)
        tabname = "Turbine #"
    elseif tabtype == "reactor" then
        fTable = formatReactor(datatable)
        tabname = "Reactor #"
    end
    
    tabname = tabname..string.sub(hostdata.hostname, -1)
    
    drawWindowBorder(window, colors.green, tabname)
    
    local x = 4
    local y = 3
    
    if tabtype == "imatrix" then
        
        addKeyValuePair(window, x, y, "Induction Providers", fTable["Induction Providers"])
        addKeyValuePair(window, x, y + 1, "Induction Cells", fTable["Induction Cells"])
        
        addKeyValuePair(window, x, y + 3, "Energy", fTable["Energy"])
        addKeyValuePair(window, x, y + 4, "Capacity", fTable["Capacity"])
        
        addKeyValuePair(window, x, y + 6, "Last Input", fTable["Last Input"])
        addKeyValuePair(window, x, y + 7, "Last Output", fTable["Last Output"])
        
        addKeyValuePair(window, x, y + 9, "Max Transfer", fTable["Max Transfer"])
        
    elseif tabtype == "turbine" then
        
        addKeyValuePair(window, x, y, "Dispersers", fTable["Dispersers"])
        addKeyValuePair(window, x, y + 1, "Condensers", fTable["Condensers"])
        addKeyValuePair(window, x, y + 2, "Blades", fTable["Blades"])
        addKeyValuePair(window, x, y + 3, "Vents", fTable["Vents"])
        addKeyValuePair(window, x, y + 4, "Coils", fTable["Coils"])
        
        addKeyValuePair(window, x, y + 6, "Steam", fTable["Steam"])
        addKeyValuePair(window, x, y + 7, "Capacity", fTable["Capacity"])
        addKeyValuePair(window, x, y + 8, "Dumping Mode", ({ string.gsub(fTable["Dumping Mode"], "_", " ") })[1])
        
        addKeyValuePair(window, x, y + 10, "Production Rate", fTable["Production Rate"])
        addKeyValuePair(window, x, y + 11, "Max Production", fTable["Max Production"])
        
        addKeyValuePair(window, x, y + 13, "Flow Rate", fTable["Flow Rate"])
        addKeyValuePair(window, x, y + 14, "Max Flow", fTable["Max Flow"])
        
        addKeyValuePair(window, x, y + 16, "Max Water Out", fTable["Max Water Output"])
        
    elseif tabtype == "reactor" then
        
        local status = "DISABLED"
        local statusColor = colors.red
        
        if fTable["Status"] then
            status = "ENABLED"
            statusColor = colors.green
        end
        
        addKeyValuePair(window, x, y, "Status", status, statusColor)
        addKeyValuePair(window, x, y + 1, "Set Burn Rate", fTable["Set Burn Rate"].." mB/t")
        addKeyValuePair(window, x, y + 2, "Actual Rate", fTable["Actual Burn Rate"].." mB/t")
        addKeyValuePair(window, x, y + 3, "Max Rate", fTable["Max Burn Rate"].." mB/t")
        
        addKeyValuePair(window, x, y + 5, "Coolant", fTable["Coolant Type"])
        addKeyValuePair(window, x, y + 6, "Amount", fTable["Coolant Amount"])
        addKeyValuePair(window, x, y + 7, "Capacity", fTable["Coolant Capacity"])
        
        addKeyValuePair(window, x, y + 9, "Heated Coolant", fTable["Heated Coolant Type"])
        addKeyValuePair(window, x, y + 10, "Amount", fTable["Heated Coolant Amount"])
        addKeyValuePair(window, x, y + 11, "Capacity", fTable["Heated Coolant Capacity"])
        
        addKeyValuePair(window, x, y + 13, "Fuel", fTable["Fuel"].." / "..fTable["Fuel Capacity"])
        addKeyValuePair(window, x, y + 14, "Waste", fTable["Waste"].." / "..fTable["Waste Capacity"])
        
        addKeyValuePair(window, x, y + 16, "Heating Rate", fTable["Heating Rate"])
        addKeyValuePair(window, x, y + 17, "Temperature", roundToPlaces(fTable["Temperature"], 2).." K")
        addKeyValuePair(window, x, y + 18, "Max Temperature", fTable["Max Temperature"])
        
        addKeyValuePair(window, x, y + 20, "Damage Percent", fTable["Damage Percent"].." %")
        addKeyValuePair(window, x, y + 21, "Environmental Loss", roundToPlaces(fTable["Environmental Loss"], 3))
        
    end
    
end

local function printImatrixLogo (window, x, y, id)
    
    local a = colors.gray
    local b = colors.black
    local c = colors.lightGray
    
    local pixelmap = {
        { b, c, c, c, c, c, c, b },
        { c, c, a, a, a, c, c, c },
        { c, c, c, a, c, c, c, c },
        { c, c, c, a, c, c, c, c },
        { c, c, a, a, a, c, c, c },
        { b, c, c, c, c, c, c, b },
    }
    
    for yy, row in pairs(pixelmap) do
        
        for xx, color in pairs(row) do
            
            addText(window, " ", xx + x - 1, yy + y - 1, color, color)
            
        end
        
    end
    
    local idx, idy = #pixelmap[1] - 1, #pixelmap - 2
    
    addText(window, id, idx + x - 1, idy + y - 1, colors.black, pixelmap[idy][idx])
    
end

local function printTurbineLogo (window, x, y, id)
    
    local a = colors.gray
    local b = colors.black
    local c = colors.lightGray
    
    local pixelmap = {
        { b, c, c, c, c, c, c, b },
        { c, c, a, a, a, c, c, c },
        { c, c, c, a, c, c, c, c },
        { c, c, c, a, c, c, c, c },
        { c, c, c, a, c, c, c, c },
        { b, c, c, c, c, c, c, b },
    }
    
    for yy, row in pairs(pixelmap) do
        
        for xx, color in pairs(row) do
            
            addText(window, " ", xx + x - 1, yy + y - 1, color, color)
            
        end
        
    end
    
    local idx, idy = #pixelmap[1] - 1, #pixelmap - 2
    
    addText(window, id, idx + x - 1, idy + y - 1, colors.black, pixelmap[idy][idx])
    
end

local function printReactorLogo (window, x, y, id)
    
    local a = colors.gray
    local b = colors.black
    local c = colors.lightGray
    
    local pixelmap = {
        { b, c, c, c, c, c, c, b },
        { c, c, a, a, c, c, c, c },
        { c, c, a, c, a, c, c, c },
        { c, c, a, a, c, c, c, c },
        { c, c, a, c, a, c, c, c },
        { b, c, c, c, c, c, c, b },
    }
    
    for yy, row in pairs(pixelmap) do
        
        for xx, color in pairs(row) do
            
            addText(window, " ", xx + x - 1, yy + y - 1, color, color)
            
        end
        
    end
    
    local idx, idy = #pixelmap[1] - 1, #pixelmap - 2
    
    addText(window, id, idx + x - 1, idy + y - 1, colors.black, pixelmap[idy][idx])
    
end

local function printArrowLogo (window, x, y, direction)
    
    local b = colors.black
    local c = colors.lightGray
    
    local pixelmap = {
        { b, b, b, c, c, b, b, b },
        { b, b, c, c, c, c, b, b },
    }
    
    for yy = 1, #pixelmap do
        
        local row
        
        if direction == "UP" then
            row = pixelmap[yy]
        elseif direction == "DOWN" then
            row = pixelmap[#pixelmap - yy + 1]
        end
        
        for xx, color in pairs(row) do
            
            addText(window, " ", xx + x - 1, yy + y - 1, color, color)
            
        end
        
    end
    
end

local function clearArrowSlot (window, x, y)
    
    local b = colors.black
    
    local pixelmap = {
        { b, b, b, b, b, b, b, b },
        { b, b, b, b, b, b, b, b },
    }
    
    for yy, row in pairs(pixelmap) do
        
        for xx, color in pairs(row) do
            
            addText(window, " ", xx + x - 1, yy + y - 1, color, color)
            
        end
        
    end
    
end

local function clearLogoSlot (window, x, y)
    
    local b = colors.black
    
    local pixelmap = {
        { b, b, b, b, b, b, b, b },
        { b, b, b, b, b, b, b, b },
        { b, b, b, b, b, b, b, b },
        { b, b, b, b, b, b, b, b },
        { b, b, b, b, b, b, b, b },
        { b, b, b, b, b, b, b, b },
    }
    
    for yy, row in pairs(pixelmap) do
        
        for xx, color in pairs(row) do
            
            addText(window, " ", xx + x - 1, yy + y - 1, color, color)
            
        end
        
    end
    
end

local function drawTablist (window, servers, visibleindex)
    
    local x = 6
    local logoYSpacing = 8
    local tablogoStartY = 8
    
    local visibletabs = {}
    
    for i = 0, 2 do
        
        local tabelement
        
        if servers[visibleindex + i] ~= nil then
            tabelement = servers[visibleindex + i]
        else
            tabelement = { id = 65000, hostname = "blank_1", hosttype = "blank" }
        end
        
        table.insert(visibletabs, tabelement)
        
    end
    
    if visibleindex ~= 1 then
        printArrowLogo(window, x, 3, "UP")
    else
        clearArrowSlot(window, x, 3)
    end
    
    for i, server in pairs(visibletabs) do
        
        local id = string.sub(server.hostname, -1)
        local type = server.hosttype
        
        if type == "reactor" then
            
            printReactorLogo(window, x, tablogoStartY + logoYSpacing * (i - 1), id)
            
        elseif type == "turbine" then
            
            printTurbineLogo(window, x, tablogoStartY + logoYSpacing * (i - 1), id)
            
        elseif type == "imatrix" then
            
            printImatrixLogo(window, x, tablogoStartY + logoYSpacing * (i - 1), id)
            
        elseif type == "blank" then
            
            clearLogoSlot(window, x, tablogoStartY + logoYSpacing * (i - 1))
            
        end
        
    end
    
    if visibleindex + 3 <= #servers then
        printArrowLogo(window, x, 33, "DOWN")
    else
        clearArrowSlot(window, x, 33)
    end
    
end

local function drawButton (window, x, y, text, color, bgColor)
    
    drawBox(window, x, y, #text + 2, 3, bgColor)
    
    addText(window, text, x + 1, y + 1, color, bgColor)
    
end

local function drawOptionsTab (window, datatable)
    
    drawWindowBorder(window, colors.red, "Options")
    
    local x = 3
    local y = 3
    
    local button1text = "ACTIVATE"
    local button1color = colors.green
    
    if datatable.Status == true then
        button1text = "SCRAM"
        button1color = colors.red
    end
    
    local button2text = "Set Burn Rate"
    
    drawButton(window, x, y, button1text, colors.white, button1color)
    
    drawButton(window, x + #button1text + 8, y, button2text, colors.black, colors.orange)
    
end

local function processOptionsEvent (x, y, window, datatable)
    
    local winX, winY = window.getPosition()
    
    local startX = 3 + winX
    local startY = 3 + winY
    
    local button1text = "ACTIVATE"
    
    if datatable.Status == true then
        button1text = "SCRAM"
    end
    
    local button2text = "Set Burn Rate"
    
    local action, value
    
    if y >= startY and y < startY + 3 then
        
        if x >= startX and x < startX + #button1text + 2 then
            action = "change_status"
            value = not datatable.Status
        elseif x >= startX + #button1text + 8 and x < startX + #button1text + 8 + #button2text + 2 then
            action = "set_burn_rate"
            print("Input new burn rate (send 'c' to cancel): ")
            value = tonumber(io.read())
            
            if value == nil or value < 0 or value > datatable.MaxBurnRate then
                action, value = nil, nil
            end
            
        end
        
    end
    
    return action, value
    
end

local function processTablistEvent (x, y, window, servers, visibleindex)
    
    local winX, winY = window.getPosition()
    
    local startX = 6 + winX
    local logoYSpacing = 8
    local tablogoStartY = 8 + winY
    
    local action, value
    
    if x >= startX and x < startX + 8 then
        
        for i = 0, 2 do
            
            if y >= tablogoStartY + logoYSpacing * i and y < tablogoStartY + logoYSpacing * i + 6 then
                action = "tab_select"
                value = visibleindex + i
            end
            
        end
        
        if visibleindex ~= 1 and y >= winY + 3 and y < winY + 3 + 2 then
            action = "scroll"
            
            if visibleindex > 3 then
                value = visibleindex - 3
            else
                value = 1
            end
            
        elseif visibleindex + 3 <= #servers and y >= winY + 33 and y < winY + 33 + 2 then
            action = "scroll"
            value = visibleindex + 3
        end
        
    end
    
    return action, value
    
end

return {
    addText = addText,
    drawBox = drawBox,
    drawWindowBorder = drawWindowBorder,
    drawMainTab = drawMainTab,
    drawTablist = drawTablist,
    drawOptionsTab = drawOptionsTab,
    processTablistEvent = processTablistEvent,
    processOptionsEvent = processOptionsEvent,
}
