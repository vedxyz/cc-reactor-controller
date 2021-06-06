
local function addText (monitor, text, x, y, color, bgColor)
    
    monitor.setCursorPos(x, y)
    monitor.setTextColor(color)
    
    if bgColor ~= nil then
        monitor.setBackgroundColor(bgColor)
    else
        monitor.setBackgroundColor(colors.black)
    end
    
    monitor.write(text)
    
end

local function drawBox (monitor, x, y, width, height, color)
    
    local prevTerm = term.redirect(monitor)
    
    paintutils.drawBox(x, y, x + width - 1, y + height - 1, color)
    monitor.setBackgroundColor(colors.black)
    
    term.redirect(prevTerm)
    
end

local function drawWindowBorder (window, color, title)
    
    local prevTerm = term.redirect(window)
    local width, height = window.getSize()
    
    paintutils.drawBox(1, 1, width, height, color)
    
    term.redirect(prevTerm)
    
    if title ~= nil then
        addText(window, " "..title.." ", 3, 1, color)
    end
    
end

return {
    addText = addText,
    drawBox = drawBox,
    drawWindowBorder = drawWindowBorder,
}
