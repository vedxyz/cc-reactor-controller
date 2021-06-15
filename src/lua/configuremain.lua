
print("What is the maximum amount of a single type of structure that is connected to this system?")
print("Example: In a system with 2 turbines, 3 reactors, 1 imatrix; this number would be 3.")
settings.set("ccmreactor.peripheral_type_max_qty", io.read())

settings.save()

local startupfile = fs.open("/startup.lua", "w")
startupfile.write("shell.run(\"/reactor/main.lua\")")
startupfile.close()

print("Startup script has been set.")
print("Configured main client.")
print("You can now run main.lua")
