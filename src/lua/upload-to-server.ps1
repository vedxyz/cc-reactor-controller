
$Files = Get-ChildItem .\* -Include *.lua
$Uploads = @{}

foreach ($File in $Files) {
    
    $Uploads.Add($File.Name, (Invoke-RestMethod `
    -Method POST `
    -Uri https://new.vedat.xyz:3000/savescript `
    -Authentication Basic `
    -Token ((Get-Content ../server/certificates/apikey.json | ConvertFrom-Json).api_key) `
    -ContentType "application/json" `
    -Body @{
        name = $File.Name;
        content = Get-Content $File -Raw;
    }))
    
}

Write-Host $Uploads.ToString()