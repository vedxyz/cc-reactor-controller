
-- 3x3 monitor size is 57w by 38h

local gui = require "guiutils"
local monitor = peripheral.wrap("left")

monitor.setTextScale(0.5)
monitor.clear()

local mainWindow = window.create(monitor, 2, 2, 36, 27)
local optionsWindow = window.create(monitor, 39, 2, 18, 36)
local tabWindow = window.create(monitor, 2, 30, 36, 8)

gui.drawWindowBorder(mainWindow, colors.green, "Current Tab")
gui.drawWindowBorder(optionsWindow, colors.red, "Options")
gui.drawWindowBorder(tabWindow, colors.gray, "Tabs")


