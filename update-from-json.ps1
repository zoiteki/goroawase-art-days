# powershell script to inject the json into the html file bc i guess i dont know how to use it as a data source 
param(
    [string]$JsonFile = "art-days.json",
    [string]$HtmlFile = "docs/index.html"
)

# Read the JSON file
$jsonContent = Get-Content $JsonFile -Raw | ConvertFrom-Json

# Convert JSON data to JavaScript array format
$jsArray = @()
foreach ($item in $jsonContent) {
    $date = $item.Date -replace '"', '\"'
    $name = $item.Name -replace '"', '\"'
    $hashtag = $item.Hashtag -replace '"', '\"'
    $explanation = $item.Explanation -replace '"', '\"'
    $exampleLink = $item.ExampleLink -replace '"', '\"'
    $examplePicture = $item.ExamplePicture -replace '"', '\"'

    $jsArray += "            { date: `"$date`", name: `"$name`", hashtag: `"$hashtag`", explanation: `"$explanation`", examplelink: `"$exampleLink`", examplepicture: `"$examplePicture`" }"
}

$jsArrayString = $jsArray -join ",`n"

# Read the current HTML file
$htmlContent = Get-Content $HtmlFile -Raw

# Find the data array section and replace it
$pattern = '(?s)(const artDays = \[)[^]]+(\];)'
$replacement = "`$1`n$jsArrayString`n        `$2"

$updatedHtml = $htmlContent -replace $pattern, $replacement

# Write the updated HTML back to file
$updatedHtml | Set-Content $HtmlFile -Encoding UTF8

Write-Host "Successfully updated $HtmlFile with data from $JsonFile"
Write-Host "Found $($jsonContent.Count) entries in the JSON file"
