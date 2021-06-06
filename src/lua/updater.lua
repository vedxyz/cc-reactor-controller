
local scriptUrls = textutils.unserializeJSON(http.get("https://new.vedat.xyz:3000/scripts").readAll())

for key, value in pairs(scriptUrls) do
    
    local file = fs.open(shell.dir().."/"..key, "w")
    file.write(http.get(value).readAll())
    file.close(key)
    
    print("Downloaded: "..key)
    
end
