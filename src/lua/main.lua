
local gui = require "guiutils"
local monitor = peripheral.wrap("left")
monitor.setTextScale(0.7)

gui.addText(monitor, "testing text", 5, 5, colors.cyan)
gui.addText(monitor, "more things", 2, 7, colors.red)

gui.drawBox(monitor, 10, 8, 4, 6)
