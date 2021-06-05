
local scriptUrls = textutils.unserializeJSON(http.get("https://new.vedat.xyz:3000/getscripts").readAll())

for key, value in pairs(scriptUrls) do
    
    print(key, value)
    
    local file = fs.open(key, "w")
    file.write(http.get(value).readAll())
    file.close(key)
    
end
