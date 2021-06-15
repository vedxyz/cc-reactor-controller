-- Configure dataserver computer

print("What is this peripheral? (turbine, imatrix, reactor)")
settings.set("ccmreactor.peripheral_type", io.read())

print("What is the side/name of this peripheral? (top, left, right, etc.)")
settings.set("ccmreactor.peripheral_side", io.read())

print("Allocation method for hostname (dynamic/static):")
settings.set("ccmreactor.hostname_allocation", io.read())

if settings.get("ccmreactor.hostname_allocation") == "static" then
    
    print("Input a static hostname ID (1,2,3,4): ")
    settings.set("ccmreactor.hostname_static_id", io.read())
    
end

settings.save()

local startupfile = fs.open("/startup.lua", "w")
startupfile.write("shell.run(\"/server/dataserver.lua\")")
startupfile.close()

print("Startup script has been set.")
print("Configured peripheral data server.")
print("You can now run dataserver.lua")
