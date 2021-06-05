
$Files = Get-ChildItem .\* -Include *.lua
$Uploads = @{}

foreach ($File in $Files) {
    
    $Uploads.Add($File.Name, (Invoke-RestMethod `
    -Method POST `
    -Uri https://pastebin.com/api/api_post.php `
    -Body @{
        api_dev_key = "";
        api_option = "paste";
        api_paste_code = Get-Content $File -Raw;
        api_paste_format = "lua";
        # api_paste_private = "1";
        api_paste_name = $File.Name;
    }))
    
}

Write-Host $Uploads.ToString()
