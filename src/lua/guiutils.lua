
local function addText (monitor, text, x, y, color)
    
    monitor.setCursorPos(x, y)
    monitor.setTextColor(color)
    
    monitor.write(text)
    
end

local function drawBox (monitor, x, y, width, height)
    
    local computerTerm = term.redirect(monitor)
    local something = ""
    
    paintutils.drawBox(x, y, x + width - 1, y + height - 1, colors.lightBlue)
    monitor.setBackgroundColor(colors.black)
    
    term.redirect(computerTerm)
    
end

return {
    addText = addText,
    drawBox = drawBox,
}
