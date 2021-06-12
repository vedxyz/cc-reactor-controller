-- Configure dataserver computer

print("What is this peripheral? (turbine, imatrix, reactor)")
settings.set("ccmreactor.peripheral_type", io.read())

print("What is the side/name of this peripheral? (top, left, right, etc.)")
settings.set("ccmreactor.peripheral_side", io.read())

settings.save()

local startupfile = fs.open("/startup.lua", "w")
startupfile.write("shell.run(\"/server/dataserver.lua\")")
startupfile.close()

print("Startup script has been set.")
print("Configured peripheral data server.")
print("You can now run dataserver.lua")
